# frozen_string_literal: true

require "date"
require "time"

require_relative "document"
require_relative "findings"
require_relative "json_schema"
require_relative "paths"
require_relative "yaml_source"

module Standards
  # Validates the OKF bundle, the governed catalog, and the source register.
  #
  # Split out of scripts/validate_catalog.rb so the passes can be driven
  # directly from tests against a temporary root, rather than only through a
  # subprocess. The entrypoint is now argument parsing plus a call to #run.
  class CatalogValidator
    GOVERNED_KEYS = %w[foundations standards patterns playbooks profiles].freeze
    SECTION_TYPES = {
      "foundations" => "foundation",
      "standards" => "standard",
      "patterns" => "pattern",
      "playbooks" => "playbook",
      "profiles" => "profile"
    }.freeze
    LIFECYCLE = {
      "draft" => "draft",
      "active" => "stable",
      "deprecated" => "deprecated",
      "retired" => "deprecated"
    }.freeze
    DOCUMENT_STATUSES = %w[draft stable deprecated].freeze
    DOCUMENT_TYPES = %w[foundation standard pattern playbook profile decision].freeze
    GOVERNANCE_STATUSES = %w[draft active deprecated retired].freeze
    VOLATILITIES = %w[low medium high].freeze
    RULE_LEVELS = %w[required recommended contextual optional avoid prohibited].freeze
    REQUIRED_FRONT_MATTER = %w[
      id title description type status governance_status owners last_reviewed applies_to tags generated
    ].freeze
    RULE_LABELS = ["Level", "Applies when", "Why", "Verify", "Exceptions"].freeze
    STANDARD_HEADINGS = %w[Guidance Examples Sources].freeze
    PROFILE_HEADINGS = ["Required standards", "Conditional standards", "Completion evidence"].freeze
    RESERVED_BASENAMES = %w[index.md log.md].freeze
    DOCUMENT_ID_PATTERN = /\A[A-Z][A-Z0-9]*(?:-[A-Z0-9]+)+\z/
    RULE_HEADING_PATTERN = /^### ((?:[A-Z][A-Z0-9]*-)+\d{3})\s+—\s+.+$/
    GOVERNED_REFERENCE_PATTERN = /`([A-Z][A-Z0-9]+(?:-[A-Z0-9]+)+)`/
    # OKF actor convention: `human:name`, `process:name`, or `vendor/model`.
    ACTOR_PATTERN = %r{\A(?:human:[^\s]+|process:[^\s]+|[^\s:/]+/[^\s/]+)\z}

    attr_reader :findings, :release_blockers, :markdown_count, :document_count, :rule_count

    def initialize(root, release: false, today: Date.today)
      @root = File.expand_path(root)
      @release = release
      @today = today
      @findings = Findings.new
      @release_blockers = Findings.new
      @documents = {}
      @ids = {}
      @rule_ids = {}
      @markdown_count = 0
      @document_count = 0
      @rule_count = 0
    end

    def release?
      @release
    end

    def valid?
      @findings.empty? && (!release? || @release_blockers.empty?)
    end

    def summary_lines
      [
        "OKF v0.2 bundle valid: #{@markdown_count} Markdown files",
        "raintree.standards catalog valid: #{@document_count} governed documents",
        "Governed rule structure valid: #{@rule_count} unique rules"
      ]
    end

    def run
      @catalog = YamlSource.load_file(File.join(@root, "catalog.yaml"), "catalog.yaml", @findings, permitted_classes: [Date])
      @sections = catalog_sections
      @entries = GOVERNED_KEYS.flat_map { |key| @sections.fetch(key) }
      @document_count = @entries.length

      check_catalog_header
      check_catalog_paths
      load_governed_documents
      check_front_matter
      check_schema_conformance
      check_dependencies
      check_rule_structure
      check_governed_references
      check_source_sections
      check_source_register
      check_markdown_bundle
      check_directory_indexes
      check_root_index
      self
    end

    private

    # -- catalog -------------------------------------------------------------

    def catalog_sections
      (%w[governance] + GOVERNED_KEYS).each_with_object({}) do |key, sections|
        rows = YamlSource.mapping_rows(@catalog.fetch(key, []), "catalog.yaml: #{key}", @findings)
        sections[key] = rows.each_with_index.each_with_object([]) do |(entry, index), valid|
          if entry["path"].to_s.empty?
            @findings.add("catalog.yaml: #{key}[#{index}] requires a path")
            next
          end
          valid << entry
        end
      end
    end

    def check_catalog_header
      @findings
        .add_unless(@catalog["okf_version"] == "0.2", "catalog.yaml: okf_version must be 0.2")
        .add_unless(@catalog["version"] == 1, "catalog.yaml: version must be 1")
        .add_unless(@catalog["bundle_index"] == "index.md", "catalog.yaml: bundle_index must be index.md")
        .add_unless(iso_date?(@catalog["updated"]), "catalog.yaml: updated must be an ISO 8601 date")
        .add_unless(non_empty_string?(@catalog["target_release"]), "catalog.yaml: target_release must be a non-empty string")
        .add_unless(non_empty_string?(@catalog["release_status"]), "catalog.yaml: release_status must be a non-empty string")

      return unless release?

      @release_blockers.add_unless(@catalog["release_status"] == "ready", "catalog.yaml: release_status must be ready")
      readme = File.join(@root, "README.md")
      unless File.file?(readme)
        @release_blockers.add("README.md: missing release entry point")
        return
      end
      return unless File.read(readme).match?(/\*\*Work in progress:\*\*/)

      @release_blockers.add("README.md: remove the work-in-progress warning before release")
    end

    def check_catalog_paths
      paths = (%w[governance] + GOVERNED_KEYS).flat_map { |key| @sections.fetch(key) }.map { |entry| entry["path"] }
      counts = Hash.new(0)

      paths.each do |relative|
        if relative.to_s.empty?
          @findings.add("catalog.yaml: every entry requires a path")
          next
        end
        counts[relative] += 1
        resolved = Paths.resolve(@root, relative)
        if resolved.nil?
          @findings.add("catalog.yaml: path #{relative} escapes the bundle root")
        elsif !File.file?(resolved)
          @findings.add("catalog.yaml: missing path #{relative}")
        end
      end

      counts.each do |relative, count|
        @findings.add("catalog.yaml: duplicate path #{relative}") if count > 1
      end
    end

    # -- governed documents --------------------------------------------------

    # Reads each governed document once. Every later pass reuses the parsed
    # result instead of re-reading and re-parsing the same file.
    def load_governed_documents
      @entries.each do |entry|
        relative = entry.fetch("path")
        next if @documents.key?(relative)

        resolved = Paths.resolve(@root, relative)
        next if resolved.nil? || !File.file?(resolved)

        @documents[relative] = Document.load(resolved, relative, @findings, permitted_classes: [Date, Time])
      end
    end

    def check_front_matter
      @entries.each do |entry|
        relative = entry.fetch("path")
        @findings.add_unless(
          !entry["id"].to_s.empty?,
          "#{relative || 'catalog.yaml'}: every governed catalog entry requires an id"
        )

        document = @documents[relative]
        if document.nil?
          @findings.add("Missing catalog path: #{relative}")
          next
        end
        unless document.front_matter?
          @findings.add("Missing YAML front matter: #{relative}")
          next
        end
        next unless document.metadata?

        check_document_metadata(entry, relative, document.metadata)
      end
    end

    def check_document_metadata(entry, relative, metadata)
      REQUIRED_FRONT_MATTER.each do |field|
        @findings.add_unless(metadata.key?(field), "#{relative}: missing #{field}")
      end

      @findings
        .add_unless(DOCUMENT_STATUSES.include?(metadata["status"]), "#{relative}: invalid OKF status #{metadata['status']}")
        .add_unless(metadata["id"].to_s.match?(DOCUMENT_ID_PATTERN), "#{relative}: invalid document ID")
        .add_unless(DOCUMENT_TYPES.include?(metadata["type"]), "#{relative}: invalid Raintree document type #{metadata['type']}")
        .add_unless(string_of_length?(metadata["description"], 3), "#{relative}: description must contain at least 3 characters")
        .add_unless(non_empty_string_list?(metadata["owners"]), "#{relative}: owners must be a non-empty list")
        .add_unless(unique_list?(metadata["applies_to"]), "#{relative}: applies_to must be a unique list")
        .add_unless(unique_list?(metadata["tags"]), "#{relative}: tags must be a unique list")
        .add_unless(metadata["depends_on"].nil? || unique_list?(metadata["depends_on"]), "#{relative}: depends_on must be a unique list")
        .add_unless(iso_date?(metadata["last_reviewed"]), "#{relative}: invalid last_reviewed date")

      if metadata.key?("release_target") && !non_empty_string?(metadata["release_target"])
        @findings.add("#{relative}: release_target must be a non-empty string")
      end

      expected_status = LIFECYCLE[metadata["governance_status"]]
      if expected_status.nil?
        @findings.add("#{relative}: invalid governance_status #{metadata['governance_status']}")
      elsif metadata["status"] != expected_status
        @findings.add("#{relative}: status #{metadata['status']} conflicts with governance_status #{metadata['governance_status']}")
      end

      generated = metadata["generated"]
      unless generated.is_a?(Hash) && !generated["by"].to_s.empty? && generated["at"]
        @findings.add("#{relative}: generated requires by and at")
      end

      if metadata["review_by"] && metadata["stale_after"] != metadata["review_by"]
        @findings.add("#{relative}: stale_after must match review_by")
      end

      catalog_id = entry["id"]
      document_id = metadata["id"]
      if catalog_id && catalog_id != document_id
        @findings.add("#{relative}: catalog ID #{catalog_id} does not match #{document_id}")
      end

      if @ids.key?(document_id)
        @findings.add("Duplicate document ID #{document_id}: #{@ids[document_id]} and #{relative}")
      else
        @ids[document_id] = relative
      end

      expected_type = SECTION_TYPES.find { |key, _type| @sections.fetch(key).include?(entry) }&.last
      if expected_type && metadata["type"] != expected_type
        @findings.add("#{relative}: catalog section requires type #{expected_type}")
      end

      return unless release? && in_release_scope?(metadata)

      if metadata["status"] == "draft" || metadata["governance_status"] == "draft"
        @release_blockers.add("#{relative}: remains draft")
      end
      check_release_gate(relative, metadata)
    end

    # Applies schema/standard.schema.json#/$defs/releaseGate.
    #
    # The rule lives in the schema rather than only in Ruby so that it stays
    # machine-readable, and it is applied here rather than in the always-on
    # schema pass because the library deliberately holds unverified stable
    # documents until v1.
    def check_release_gate(relative, metadata)
      gate = standard_schema&.dig("$defs", "releaseGate")
      return if gate.nil?
      return if JsonSchema.validate(metadata, wrap_gate(gate), label: "").empty?

      @release_blockers.add("#{relative}: stable release document requires independent verified provenance")
    end

    # The gate subschema uses no $ref, but it is validated against a root that
    # still carries $defs so any future reference inside it resolves.
    def wrap_gate(gate)
      gate.merge("$defs" => standard_schema.fetch("$defs", {}))
    end

    # Applies schema/standard.schema.json to the front matter it describes.
    #
    # Before this, the schema was parsed but never applied, so its constraints
    # were free to drift from the checks above. Any drift now surfaces as a
    # validation failure on a real document.
    def check_schema_conformance
      schema = standard_schema
      return if schema.nil?

      @documents.each do |relative, document|
        next unless document.metadata?

        begin
          JsonSchema.validate(document.metadata, schema, label: "").each do |message|
            @findings.add("#{relative}: front matter #{message}")
          end
        rescue JsonSchema::UnsupportedKeyword => e
          @findings.add("schema/standard.schema.json: #{e.message}")
          return
        end
      end
    end

    def check_dependencies
      @entries.each do |entry|
        relative = entry.fetch("path")
        document = @documents[relative]
        next unless document&.metadata?

        metadata = document.metadata
        scoped = release? && in_release_scope?(metadata)
        Array(metadata["depends_on"]).each do |dependency|
          @findings.add_unless(@ids.key?(dependency), "#{relative}: unknown dependency #{dependency}")
          next unless scoped

          dependency_path = @ids[dependency]
          dependency_metadata = dependency_path && @documents[dependency_path]&.metadata
          next unless dependency_metadata && dependency_metadata["status"] == "draft"

          @release_blockers.add("#{relative}: depends on draft #{dependency}")
        end
      end
    end

    # Governed rules and profiles have semantic structure beyond front matter.
    def check_rule_structure
      @entries.each do |entry|
        relative = entry.fetch("path")
        document = @documents[relative]
        next unless document&.metadata?

        metadata = document.metadata
        check_rules(document, relative, metadata) if %w[foundation standard].include?(metadata["type"])
        check_profile(document, relative, metadata) if metadata["type"] == "profile"
      end
      @rule_count = @rule_ids.length
    end

    def check_rules(document, relative, metadata)
      STANDARD_HEADINGS.each do |heading|
        @findings.add_unless(document.heading?(2, heading), "#{relative}: missing ## #{heading}")
      end

      content = document.content
      headings = content.to_enum(:scan, RULE_HEADING_PATTERN).map { Regexp.last_match }
      @findings.add("#{relative}: no governed rules") if headings.empty?

      headings.each_with_index do |heading, index|
        rule_id = heading[1]
        if @rule_ids.key?(rule_id)
          @findings.add("Duplicate rule ID #{rule_id}: #{@rule_ids[rule_id]} and #{relative}")
        else
          @rule_ids[rule_id] = relative
        end
        unless rule_id.start_with?("#{metadata['id']}-")
          @findings.add("#{relative}: rule #{rule_id} does not match document ID #{metadata['id']}")
        end

        block_start = heading.end(0)
        block_end = if index + 1 < headings.length
                      headings[index + 1].begin(0)
                    else
                      content.index(/^## /, block_start) || content.length
                    end
        block = content[block_start...block_end]

        RULE_LABELS.each do |label|
          @findings.add_unless(block.match?(/\*\*#{Regexp.escape(label)}:\*\*/), "#{relative}: #{rule_id} missing #{label}")
        end
        level = block[/\*\*Level:\*\*\s*([^\n]+)/, 1]
        @findings.add_unless(RULE_LEVELS.include?(level), "#{relative}: #{rule_id} has invalid level #{level}")
      end
    end

    def check_profile(document, relative, metadata)
      PROFILE_HEADINGS.each do |heading|
        @findings.add_unless(document.heading?(2, heading), "#{relative}: missing ## #{heading}")
      end

      listed = document.section("Required standards").to_s.scan(/^- `([A-Z][A-Z0-9-]+)`/).flatten
      dependencies = Array(metadata["depends_on"])
      return if listed.sort == dependencies.sort

      @findings.add("#{relative}: Required standards must match depends_on")
    end

    # Validated after all rule IDs are known, so a forward reference to a rule
    # defined in a later document still resolves.
    def check_governed_references
      @documents.each do |relative, document|
        document.content.scan(GOVERNED_REFERENCE_PATTERN).flatten.uniq.each do |reference|
          next if @ids.key?(reference) || @rule_ids.key?(reference)

          @findings.add("#{relative}: unknown governed reference #{reference}")
        end
      end
    end

    # Front-matter sources and the visible Sources section must agree.
    def check_source_sections
      @documents.each do |relative, document|
        next unless document.metadata? && document.metadata["sources"]

        front = Array(document.metadata["sources"]).map { |source| source.is_a?(Hash) ? source["resource"] : nil }.compact
        body = document.section("Sources").to_s.scan(%r{\]\((https?://[^)]+)\)}).flatten
        next if front.sort == body.sort

        @findings.add("#{relative}: front-matter and visible source URLs differ")
      end
    end

    # -- source register -----------------------------------------------------

    def check_source_register
      path = File.join(@root, "source-register.yaml")
      unless File.file?(path)
        @findings.add("Missing source-register.yaml")
        return
      end

      register = YamlSource.load_file(path, "source-register.yaml", @findings, permitted_classes: [Date])
      @findings
        .add_unless(register["version"] == 1, "source-register.yaml: version must be 1")
        .add_unless(iso_date?(register["updated"]), "source-register.yaml: updated must be an ISO 8601 date")
        .add_unless(non_empty_string?(register["description"]), "source-register.yaml: description must be a non-empty string")

      rows = YamlSource.mapping_rows(register.fetch("documents", []), "source-register.yaml: documents", @findings)
      records = rows.each_with_index.each_with_object([]) do |(record, index), valid|
        if record["id"].to_s.empty?
          @findings.add("source-register.yaml: documents[#{index}] requires an id")
          next
        end
        valid << record
      end

      records.group_by { |record| record["id"] }.each do |id, duplicates|
        @findings.add("source-register.yaml: duplicate document ID #{id}") if duplicates.length > 1
      end

      registered = records.to_h { |record| [record["id"], record] }
      sourced = sourced_document_ids
      registered.each { |id, record| check_register_record(id, record, sourced) }

      @entries.each do |entry|
        document = @documents[entry.fetch("path")]
        next unless document&.metadata? && document.metadata["sources"]
        next if registered.key?(entry["id"])

        @findings.add("source-register.yaml: missing #{entry['id']}")
      end
    end

    def sourced_document_ids
      @entries.each_with_object([]) do |entry, result|
        document = @documents[entry.fetch("path")]
        result << entry["id"] if document&.metadata? && document.metadata["sources"]
      end
    end

    def check_register_record(id, record, sourced)
      if !@ids.key?(id)
        @findings.add("source-register.yaml: unknown document ID #{id}")
      elsif !sourced.include?(id)
        @findings.add("source-register.yaml: #{id} has no front-matter sources")
      end

      %w[owner source_version].each do |field|
        @findings.add_unless(
          non_empty_string?(record[field]),
          "source-register.yaml: #{id} #{field} must be a non-empty string"
        )
      end

      @findings
        .add_unless(iso_date?(record["reviewed_on"]), "source-register.yaml: #{id} invalid reviewed_on date")
        .add_unless(iso_date?(record["next_review"]), "source-register.yaml: #{id} invalid next_review date")
        .add_unless(VOLATILITIES.include?(record["volatility"]), "source-register.yaml: #{id} invalid volatility #{record['volatility']}")

      return unless iso_date?(record["reviewed_on"]) && iso_date?(record["next_review"])

      reviewed_on = as_date(record["reviewed_on"])
      next_review = as_date(record["next_review"])
      @findings.add_unless(next_review > reviewed_on, "source-register.yaml: #{id} next_review must be after reviewed_on")
      return unless @today > next_review

      @findings.add("source-register.yaml: #{id} source review expired on #{record['next_review']}")
    end

    # -- bundle-wide Markdown ------------------------------------------------

    def check_markdown_bundle
      files = Paths.glob(@root, "**/*.md")
      @markdown_count = files.length
      @findings.add("index.md: bundle contains no Markdown files") if files.empty?

      files.each do |relative|
        # One read per file. The passes below all work from this content.
        content = File.read(File.join(@root, relative))
        basename = File.basename(relative)

        if RESERVED_BASENAMES.include?(basename)
          check_reserved_markdown(content, relative, basename)
        else
          check_bundle_front_matter(content, relative)
        end

        check_links(content, relative)
      end
    end

    def check_reserved_markdown(content, relative, basename)
      if basename == "index.md" && relative == "index.md"
        findings = Findings.new
        document = Document.new(relative, content, findings)
        findings.each { |message| @findings.add(message) }
        unless document.metadata? && document.metadata["okf_version"] == "0.2"
          @findings.add("index.md: root index must declare okf_version 0.2")
        end
      elsif content.start_with?("---\n")
        @findings.add("#{relative}: reserved nested files must not contain front matter")
      end
    end

    def check_bundle_front_matter(content, relative)
      # Governed documents were already read and parsed; reuse that result
      # rather than parsing the same front matter a second time.
      document = @documents[relative] || Document.new(relative, content, @findings)
      unless document.front_matter?
        @findings.add("#{relative}: missing OKF YAML front matter")
        return
      end
      return unless document.metadata?

      metadata = document.metadata
      @findings
        .add_unless(non_blank_string?(metadata["type"]), "#{relative}: missing non-empty OKF type")
        .add_unless(non_blank_string?(metadata["description"]), "#{relative}: missing OKF description")

      if metadata.key?("status") && !DOCUMENT_STATUSES.include?(metadata["status"])
        @findings.add("#{relative}: invalid OKF lifecycle status #{metadata['status']}")
      end

      if metadata.key?("stale_after") && !iso_date?(metadata["stale_after"])
        @findings.add("#{relative}: stale_after must be an ISO 8601 date")
      end

      generated = metadata["generated"]
      unless generated.is_a?(Hash)
        @findings.add("#{relative}: missing generated provenance")
        generated = {}
      end

      generated_by = generated["by"]
      unless generated_by.is_a?(String) && generated_by.match?(ACTOR_PATTERN)
        @findings.add("#{relative}: generated.by does not follow the OKF actor convention")
      end

      if generated["at"] && !iso_datetime?(generated["at"])
        @findings.add("#{relative}: generated.at must be an ISO 8601 datetime")
      end

      check_verification(relative, metadata, generated_by)
      check_source_ids(relative, metadata)
    end

    def check_verification(relative, metadata, generated_by)
      return unless metadata.key?("verified")

      events = metadata["verified"].is_a?(Hash) ? [metadata["verified"]] : metadata["verified"]
      unless events.is_a?(Array) && !events.empty?
        @findings.add("#{relative}: verified must be a mapping or non-empty list")
        return
      end

      events.each do |event|
        unless event.is_a?(Hash) && event["by"].is_a?(String) && event["by"].match?(ACTOR_PATTERN)
          @findings.add("#{relative}: verified.by does not follow the OKF actor convention")
        end
        unless event.is_a?(Hash) && iso_datetime?(event["at"])
          @findings.add("#{relative}: verified.at must be an ISO 8601 datetime")
        end
        next unless event.is_a?(Hash) && generated_by.is_a?(String) && event["by"] == generated_by

        @findings.add("#{relative}: verified.by must differ from generated.by")
      end
    end

    def check_source_ids(relative, metadata)
      ids = []
      Array(metadata["sources"]).each do |source|
        @findings.add_unless(
          source.is_a?(Hash) && !source["resource"].to_s.empty?,
          "#{relative}: every OKF source needs a resource"
        )
        ids << source["id"] if source.is_a?(Hash) && source["id"]
      end
      @findings.add_unless(ids.uniq.length == ids.length, "#{relative}: source IDs must be unique")
    end

    def check_links(content, relative)
      content.scan(/\[[^\]]+\]\(([^)]+)\)/).flatten.each do |raw|
        target = raw.strip.sub(/\A</, "").sub(/>\z/, "").split(/[?#]/, 2).first.to_s
        next if target.empty? || target.start_with?("#") || target.match?(%r{\A[a-z][a-z0-9+.-]*:}i)

        resolved = if target.start_with?("/")
                     Paths.resolve(@root, target.delete_prefix("/"))
                   else
                     Paths.resolve(@root, File.join(File.dirname(relative), target))
                   end

        if resolved.nil?
          @findings.add("Markdown link escapes the bundle in #{relative}: #{raw}")
          next
        end

        resolved = File.join(resolved, "index.md") if target.end_with?("/")
        @findings.add_unless(File.file?(resolved), "Broken Markdown link in #{relative}: #{raw}")
      end
    end

    # Directory indexes are intentionally simple, but they must not become stale.
    def check_directory_indexes
      Paths.glob(@root, "*/**/index.md").each do |relative|
        directory = File.dirname(relative)
        expected = Paths.glob(@root, File.join(directory, "*.md"))
          .map { |path| File.basename(path) }
          .reject { |name| RESERVED_BASENAMES.include?(name) }
          .sort
        linked = File.read(File.join(@root, relative))
          .scan(/\[[^\]]+\]\(([^)]+\.md)\)/)
          .flatten
          .reject { |target| target.match?(%r{\Ahttps?://}) }
          .map { |target| File.basename(target) }
          .sort

        missing = expected - linked
        extra = linked - expected
        @findings.add("#{relative}: missing entries for #{missing.join(', ')}") unless missing.empty?
        @findings.add("#{relative}: unexpected entries for #{extra.join(', ')}") unless extra.empty?
      end
    end

    # The root index is the bundle's discovery boundary. It must expose every
    # root concept and every indexed top-level area, though it may link deeper.
    def check_root_index
      root_index = File.join(@root, "index.md")
      unless File.file?(root_index)
        @findings.add("Missing index.md")
        return
      end

      targets = File.read(root_index)
        .scan(/\[[^\]]+\]\(([^)]+)\)/)
        .flatten
        .map { |target| target.split(/[?#]/, 2).first }

      expected = Paths.glob(@root, "*.md").reject { |name| RESERVED_BASENAMES.include?(name) }
      expected += Paths.glob(@root, "*/index.md").map { |path| "#{File.dirname(path)}/" }

      missing = expected.uniq.sort - targets
      return if missing.empty?

      @findings.add("index.md: missing root entries for #{missing.join(', ')}")
    end

    # -- schema --------------------------------------------------------------

    # Loads schema/standard.schema.json once. A missing file is not a finding:
    # the schema is optional infrastructure, and its absence is reported by the
    # workflow's schema-parsing step rather than by every document in turn.
    def standard_schema
      return @standard_schema if defined?(@standard_schema)

      path = File.join(@root, "schema", "standard.schema.json")
      @standard_schema =
        if File.file?(path)
          begin
            JSON.parse(File.read(path))
          rescue JSON::ParserError => e
            @findings.add("schema/standard.schema.json: invalid JSON (#{e.message.lines.first.to_s.strip})")
            nil
          end
        end
    end

    # -- predicates ----------------------------------------------------------

    def in_release_scope?(metadata)
      metadata.fetch("release_target", @catalog["target_release"]) == @catalog["target_release"]
    end

    def as_date(value)
      value.is_a?(Date) ? value : Date.iso8601(value.to_s)
    end

    def iso_date?(value)
      return true if value.is_a?(Date)
      return false unless value.is_a?(String)

      Date.iso8601(value)
      true
    rescue ArgumentError
      false
    end

    def iso_datetime?(value)
      return true if value.is_a?(Time) || value.is_a?(DateTime)
      return false unless value.is_a?(String)

      Time.iso8601(value)
      true
    rescue ArgumentError
      false
    end

    def non_empty_string?(value)
      value.is_a?(String) && !value.empty?
    end

    def non_blank_string?(value)
      value.is_a?(String) && !value.strip.empty?
    end

    def string_of_length?(value, minimum)
      value.is_a?(String) && value.length >= minimum
    end

    def non_empty_string_list?(value)
      value.is_a?(Array) && !value.empty? && value.all? { |item| non_empty_string?(item) }
    end

    def unique_list?(value)
      value.is_a?(Array) && value.uniq.length == value.length
    end
  end
end
