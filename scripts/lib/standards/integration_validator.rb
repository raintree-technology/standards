# frozen_string_literal: true

require "date"
require "json"

require_relative "findings"
require_relative "json_schema"
require_relative "paths"
require_relative "yaml_source"

module Standards
  # Validates a governed vendor integration capability bundle.
  #
  # Split out of scripts/validate_integrations.rb so the passes can be driven
  # directly from tests. Every row access goes through YamlSource.mapping_rows,
  # so a malformed document produces validation messages instead of the
  # TypeError and NoMethodError backtraces the previous version raised on a
  # top-level sequence, an empty file, or a scalar list entry.
  class IntegrationValidator
    INTEGRATION = "google-search-console"

    FILES = {
      sources: "sources.yaml",
      capabilities: "capabilities.yaml",
      semantics: "data-semantics.yaml",
      workflows: "workflows.yaml",
      evaluations: "evaluations.yaml"
    }.freeze

    TOP_LEVEL_KEYS = {
      sources: %w[version integration reviewed_on scope freshness sources change_watch coverage],
      capabilities: %w[version integration reviewed_on capabilities],
      semantics: %w[version integration reviewed_on concepts],
      workflows: %w[version integration workflows],
      evaluations: %w[version integration evaluations]
    }.freeze

    CAPABILITY_FIELDS = %w[
      id name interface availability access effect approval inputs outputs data_semantics limits
      limitations verification idempotency rollback sources
    ].freeze
    CAPABILITY_STRING_LISTS = %w[inputs outputs data_semantics limitations verification sources].freeze
    # Fields whose emptiness is allowed because an empty list is meaningful:
    # a read-only capability may need no OAuth scope at all.
    OPTIONALLY_EMPTY = %w[oauth_scopes property_roles].freeze

    INTERFACES = %w[search_console_api search_console_ui bigquery_export email_notification indexing_api external_google_tool].freeze
    AVAILABILITIES = %w[current adjacent legacy unavailable].freeze
    EFFECTS = %w[observe diagnose mutate_reversible mutate_high_impact human_only].freeze
    APPROVALS = %w[none bounded exact human_only].freeze
    ROLES = %w[none restricted_user full_user owner verified_owner google_cloud_role].freeze
    OAUTH_SCOPES = %w[
      https://www.googleapis.com/auth/webmasters.readonly
      https://www.googleapis.com/auth/webmasters
      https://www.googleapis.com/auth/indexing
    ].freeze
    LIMIT_DIMENSIONS = %w[quotas latency sampling privacy_suppression aggregation completeness operational].freeze
    CLASSIFICATIONS = %w[mapped adjacent legacy excluded].freeze
    WATCH_STATUSES = %w[announced_deprecation limited_rollout provider_change].freeze
    AUTHORITIES = %w[provider_documentation].freeze
    VOLATILITIES = %w[low medium high].freeze
    MUTATING_EFFECTS = %w[mutate_reversible mutate_high_impact].freeze
    ROUTED_EFFECTS = %w[mutate_reversible mutate_high_impact human_only].freeze
    OFFICIAL_URL = %r{\Ahttps://(?:developers\.google\.com|support\.google\.com|status\.search\.google\.com|trends\.google\.com)/}

    attr_reader :findings

    def initialize(root, today: Date.today)
      @root = File.expand_path(root)
      @bundle = File.join(@root, "integrations", INTEGRATION)
      @today = today
      @findings = Findings.new
      @documents = {}
      @rows = {}
      @registry = {}
      @covered_sources = []
    end

    def valid?
      @findings.empty?
    end

    def summary_lines
      ["Integration bundle valid: #{count(:capabilities)} capabilities, #{@coverage.length} coverage surfaces, " \
       "#{count(:workflows)} workflows, #{count(:evaluations)} evaluations, #{count(:change_watch)} change watches"]
    end

    # Returns false when required artifacts are missing, which is a hard stop:
    # every later pass would report the same absence a second time.
    def artifacts_present?
      FILES.each_value do |name|
        path = File.join(@bundle, name)
        @findings.add("Missing integration artifact: #{Paths.relative(@root, path)}") unless File.file?(path)
      end
      unless File.file?(schema_path)
        @findings.add("Missing integration schema: schema/integration-capability.schema.json")
      end
      @findings.empty?
    end

    def run
      load_documents
      check_top_level
      index_rows
      check_capabilities
      check_schema_conformance
      check_coverage
      check_semantics
      check_workflows
      check_evaluations
      check_mutation_routing
      check_sources
      check_freshness
      check_change_watch
      check_unused_sources
      self
    end

    private

    def schema_path
      File.join(@root, "schema", "integration-capability.schema.json")
    end

    def load_documents
      FILES.each do |kind, name|
        path = File.join(@bundle, name)
        @documents[kind] = YamlSource.load_file(path, name, @findings, permitted_classes: [Date])
      end
    end

    def check_top_level
      @documents.each do |kind, document|
        relative = FILES.fetch(kind)
        @findings
          .add_unless(document["version"] == 1, "#{relative}: version must be 1")
          .add_unless(document["integration"] == INTEGRATION, "#{relative}: integration must be #{INTEGRATION}")

        expected = TOP_LEVEL_KEYS.fetch(kind)
        unknown = document.keys - expected
        missing = expected - document.keys
        @findings.add("#{relative}: unknown top-level fields #{unknown.join(', ')}") unless unknown.empty?
        @findings.add("#{relative}: missing top-level fields #{missing.join(', ')}") unless missing.empty?
      end
    end

    def index_rows
      @rows[:sources] = rows_for(:sources, "sources", "sources.yaml: sources")
      @rows[:capabilities] = rows_for(:capabilities, "capabilities", "capabilities.yaml: capabilities")
      @rows[:semantics] = rows_for(:semantics, "concepts", "data-semantics.yaml: concepts")
      @rows[:workflows] = rows_for(:workflows, "workflows", "workflows.yaml: workflows")
      @rows[:evaluations] = rows_for(:evaluations, "evaluations", "evaluations.yaml: evaluations")
      @rows[:coverage] = rows_for(:sources, "coverage", "sources.yaml: coverage")
      @rows[:change_watch] = rows_for(:sources, "change_watch", "sources.yaml: change_watch")

      @sources = collect(:sources, "id", "source")
      @capabilities = collect(:capabilities, "id", "capability")
      @semantics = collect(:semantics, "id", "semantic")
      @workflows = collect(:workflows, "id", "workflow")
      @evaluations = collect(:evaluations, "id", "evaluation")
      @coverage = collect(:coverage, "surface", "coverage")
      @change_watch = collect(:change_watch, "id", "change watch")

      seen = {}
      [
        [@sources, "source"], [@capabilities, "capability"], [@semantics, "semantic"],
        [@workflows, "workflow"], [@evaluations, "evaluation"], [@change_watch, "change watch"]
      ].each do |mapping, label|
        mapping.each_key do |id|
          @findings.add("Duplicate integration ID #{id} across #{seen[id]} and #{label}") if seen.key?(id)
          seen[id] = label
        end
      end
    end

    def rows_for(kind, field, label)
      YamlSource.mapping_rows(@documents.fetch(kind)[field], label, @findings)
    end

    def collect(kind, field, label)
      @rows.fetch(kind).each_with_index.each_with_object({}) do |(row, index), found|
        value = row[field]
        if value.to_s.empty?
          @findings.add("#{label}[#{index}]: missing #{field}")
        elsif found.key?(value)
          @findings.add("Duplicate #{label} #{field} #{value}")
        else
          found[value] = row
        end
      end
    end

    def count(kind)
      case kind
      when :capabilities then @capabilities.length
      when :workflows then @workflows.length
      when :evaluations then @evaluations.length
      when :change_watch then @change_watch.length
      end
    end

    # -- capabilities --------------------------------------------------------

    def check_capabilities
      @rows.fetch(:capabilities).each_with_index do |row, index|
        prefix = "capabilities.yaml: capability[#{index}] #{row['id']}"
        unknown = row.keys - CAPABILITY_FIELDS
        @findings.add("#{prefix}: unknown fields #{unknown.join(', ')}") unless unknown.empty?

        CAPABILITY_FIELDS.each do |field|
          value = row[field]
          blank = value.nil? || value == "" ||
                  (value.respond_to?(:empty?) && value.empty? && !OPTIONALLY_EMPTY.include?(field))
          @findings.add("#{prefix}: missing #{field}") if blank
        end

        @findings
          .add_unless(INTERFACES.include?(row["interface"]), "#{prefix}: invalid interface #{row['interface']}")
          .add_unless(AVAILABILITIES.include?(row["availability"]), "#{prefix}: invalid availability #{row['availability']}")
          .add_unless(EFFECTS.include?(row["effect"]), "#{prefix}: invalid effect #{row['effect']}")
          .add_unless(APPROVALS.include?(row["approval"]), "#{prefix}: invalid approval #{row['approval']}")

        check_access(prefix, row["access"])
        check_capability_lists(prefix, row)
        check_limits(prefix, row["limits"])
        check_capability_sources(prefix, row)
        check_effect_rules(prefix, row)
      end
    end

    def check_access(prefix, access)
      unless access.is_a?(Hash) && access["oauth_scopes"].is_a?(Array) && access["property_roles"].is_a?(Array)
        @findings.add("#{prefix}: access requires oauth_scopes and property_roles arrays")
        return
      end

      unknown = access.keys - %w[oauth_scopes property_roles]
      @findings.add("#{prefix}: unknown access fields #{unknown.join(', ')}") unless unknown.empty?
      @findings.add("#{prefix}: property_roles must declare at least one role") if access["property_roles"].empty?

      unknown_roles = access["property_roles"] - ROLES
      @findings.add("#{prefix}: invalid property roles #{unknown_roles.join(', ')}") unless unknown_roles.empty?
      unknown_scopes = access["oauth_scopes"] - OAUTH_SCOPES
      @findings.add("#{prefix}: invalid OAuth scopes #{unknown_scopes.join(', ')}") unless unknown_scopes.empty?
    end

    def check_capability_lists(prefix, row)
      CAPABILITY_STRING_LISTS.each do |field|
        @findings.add_unless(
          string_list?(row[field]),
          "#{prefix}: #{field} must be a non-empty unique string list"
        )
      end
    end

    def check_limits(prefix, limits)
      if !limits.is_a?(Hash) || limits.keys.sort != LIMIT_DIMENSIONS.sort
        @findings.add("#{prefix}: limits must declare exactly #{LIMIT_DIMENSIONS.join(', ')}")
        return
      end

      LIMIT_DIMENSIONS.each do |dimension|
        @findings.add_unless(
          string_list?(limits[dimension]),
          "#{prefix}: limits.#{dimension} must be a non-empty unique string list"
        )
      end
    end

    def check_capability_sources(prefix, row)
      Array(row["sources"]).each do |id|
        @findings.add_unless(@sources.key?(id), "#{prefix}: unknown source #{id}")
      end
    end

    def check_effect_rules(prefix, row)
      if MUTATING_EFFECTS.include?(row["effect"])
        @findings.add("#{prefix}: mutation cannot use approval none") if row["approval"] == "none"
        @findings.add("#{prefix}: mutation requires verification") if Array(row["verification"]).empty?
        if row["rollback"].to_s.empty? || row["rollback"] == "Not applicable"
          @findings.add("#{prefix}: mutation requires rollback or irreversibility text")
        end
      end

      if row["effect"] == "mutate_high_impact" && !%w[exact human_only].include?(row["approval"])
        @findings.add("#{prefix}: high-impact mutation requires exact or human_only approval")
      end
      if %w[observe diagnose].include?(row["effect"]) && row["approval"] != "none"
        @findings.add("#{prefix}: observe and diagnose effects require approval none")
      end
      return unless row["effect"] == "human_only" && row["approval"] != "human_only"

      @findings.add("#{prefix}: human_only effect requires human_only approval")
    end

    # Applies schema/integration-capability.schema.json to capabilities.yaml.
    #
    # The schema previously only had to parse. Applying it means its enums,
    # patterns, and effect/approval conditionals are enforced on real rows, and
    # scripts/test_schema_drift.rb asserts they still agree with the constants
    # above rather than quietly diverging.
    def check_schema_conformance
      return unless File.file?(schema_path)

      begin
        schema = JSON.parse(File.read(schema_path))
      rescue JSON::ParserError => e
        @findings.add("schema/integration-capability.schema.json: invalid JSON (#{e.message.lines.first.to_s.strip})")
        return
      end

      JsonSchema.validate(@documents.fetch(:capabilities), schema, label: "").each do |message|
        @findings.add("capabilities.yaml: #{message}")
      end
    rescue JsonSchema::UnsupportedKeyword => e
      @findings.add("schema/integration-capability.schema.json: #{e.message}")
    end

    # -- coverage, semantics, workflows, evaluations -------------------------

    def check_coverage
      covered_capabilities = []
      @rows.fetch(:coverage).each_with_index do |row, index|
        prefix = "sources.yaml: coverage[#{index}] #{row['surface']}"
        unknown = row.keys - %w[surface classification capabilities sources rationale]
        @findings.add("#{prefix}: unknown fields #{unknown.join(', ')}") unless unknown.empty?

        classification = row["classification"]
        @findings.add_unless(CLASSIFICATIONS.include?(classification), "#{prefix}: invalid classification #{classification}")

        caps = Array(row["capabilities"])
        refs = Array(row["sources"])
        @findings.add("#{prefix}: sources must be non-empty") if refs.empty?

        if %w[adjacent legacy excluded].include?(classification)
          @findings.add("#{prefix}: #{classification} surface requires rationale") if row["rationale"].to_s.empty?
        elsif caps.empty?
          @findings.add("#{prefix}: non-excluded surface requires capabilities")
        end

        caps.each { |id| @findings.add_unless(@capabilities.key?(id), "#{prefix}: unknown capability #{id}") }
        refs.each { |id| @findings.add_unless(@sources.key?(id), "#{prefix}: unknown source #{id}") }

        covered_capabilities.concat(caps)
        @covered_sources.concat(refs)
      end

      (@capabilities.keys - covered_capabilities.uniq).each do |id|
        @findings.add("sources.yaml: zero-gap ledger does not classify capability #{id}")
      end
    end

    def check_semantics
      @rows.fetch(:semantics).each_with_index do |row, index|
        prefix = "data-semantics.yaml: concept[#{index}] #{row['id']}"
        unknown = row.keys - %w[id name definition cautions sources]
        @findings.add("#{prefix}: unknown fields #{unknown.join(', ')}") unless unknown.empty?
        %w[name definition].each { |field| @findings.add("#{prefix}: missing #{field}") if row[field].to_s.empty? }
        @findings.add_unless(non_empty_array?(row["cautions"]), "#{prefix}: cautions must be non-empty")

        Array(row["sources"]).each do |id|
          @findings.add_unless(@sources.key?(id), "#{prefix}: unknown source #{id}")
          @covered_sources << id
        end
      end
    end

    def check_workflows
      @rows.fetch(:workflows).each_with_index do |row, index|
        prefix = "workflows.yaml: workflow[#{index}] #{row['id']}"
        unknown = row.keys - %w[id name trigger capabilities steps stop_conditions outputs]
        @findings.add("#{prefix}: unknown fields #{unknown.join(', ')}") unless unknown.empty?
        %w[name trigger].each { |field| @findings.add("#{prefix}: missing #{field}") if row[field].to_s.empty? }
        %w[capabilities steps stop_conditions outputs].each do |field|
          @findings.add_unless(non_empty_array?(row[field]), "#{prefix}: #{field} must be non-empty")
        end
        Array(row["capabilities"]).each { |id| @findings.add_unless(@capabilities.key?(id), "#{prefix}: unknown capability #{id}") }
      end
    end

    def check_evaluations
      @rows.fetch(:evaluations).each_with_index do |row, index|
        prefix = "evaluations.yaml: evaluation[#{index}] #{row['id']}"
        unknown = row.keys - %w[id workflow capabilities scenario evidence expected prohibited]
        @findings.add("#{prefix}: unknown fields #{unknown.join(', ')}") unless unknown.empty?
        %w[scenario expected prohibited].each { |field| @findings.add("#{prefix}: missing #{field}") if row[field].to_s.empty? }
        @findings
          .add_unless(non_empty_array?(row["evidence"]), "#{prefix}: evidence must be non-empty")
          .add_unless(@workflows.key?(row["workflow"]), "#{prefix}: unknown workflow #{row['workflow']}")
        Array(row["capabilities"]).each { |id| @findings.add_unless(@capabilities.key?(id), "#{prefix}: unknown capability #{id}") }
      end
    end

    def check_mutation_routing
      mutation_ids = @rows.fetch(:capabilities)
        .select { |row| ROUTED_EFFECTS.include?(row["effect"]) }
        .map { |row| row["id"] }
      routed = @rows.fetch(:workflows).flat_map { |row| Array(row["capabilities"]) } +
               @rows.fetch(:evaluations).flat_map { |row| Array(row["capabilities"]) }

      (mutation_ids - routed.uniq).each do |id|
        @findings.add("capabilities.yaml: mutation #{id} is not routed through a workflow or evaluation")
      end
    end

    # -- sources -------------------------------------------------------------

    def check_sources
      @rows.fetch(:sources).each_with_index do |row, index|
        prefix = "sources.yaml: source[#{index}] #{row['id']}"
        unknown = row.keys - %w[id title url topic authority volatility]
        @findings.add("#{prefix}: unknown fields #{unknown.join(', ')}") unless unknown.empty?
        %w[title url topic authority volatility].each do |field|
          @findings.add("#{prefix}: missing #{field}") if row[field].to_s.empty?
        end
        @findings
          .add_unless(AUTHORITIES.include?(row["authority"]), "#{prefix}: invalid authority #{row['authority']}")
          .add_unless(VOLATILITIES.include?(row["volatility"]), "#{prefix}: invalid volatility #{row['volatility']}")
          .add_unless(row["url"].to_s.match?(OFFICIAL_URL), "#{prefix}: URL must use official Google HTTPS documentation")
      end
    end

    def check_freshness
      freshness = @documents.fetch(:sources)["freshness"]
      unless freshness.is_a?(Hash) &&
             freshness["cadence_days"].is_a?(Integer) && freshness["cadence_days"].positive? &&
             freshness["next_review"].is_a?(Date) &&
             non_empty_array?(freshness["event_triggers"])
        @findings.add("sources.yaml: freshness requires a positive cadence_days, next_review date, and non-empty event_triggers")
        return
      end

      reviewed_on = @documents.fetch(:sources)["reviewed_on"]
      next_review = freshness["next_review"]
      if reviewed_on.is_a?(Date)
        @findings
          .add_unless(next_review > reviewed_on, "sources.yaml: freshness next_review must be after reviewed_on")
          .add_unless(next_review <= reviewed_on + freshness["cadence_days"], "sources.yaml: freshness next_review exceeds cadence_days")
      end
      return unless @today > next_review

      @findings.add("sources.yaml: official-source review expired on #{next_review}")
    end

    def check_change_watch
      @rows.fetch(:change_watch).each_with_index do |row, index|
        prefix = "sources.yaml: change_watch[#{index}] #{row['id']}"
        unknown = row.keys - %w[id status effective affected_capabilities action sources]
        @findings.add("#{prefix}: unknown fields #{unknown.join(', ')}") unless unknown.empty?
        @findings.add_unless(WATCH_STATUSES.include?(row["status"]), "#{prefix}: invalid status #{row['status']}")
        %w[effective action].each { |field| @findings.add("#{prefix}: missing #{field}") if row[field].to_s.empty? }
        @findings
          .add_unless(non_empty_array?(row["affected_capabilities"]), "#{prefix}: affected_capabilities must be non-empty")
          .add_unless(non_empty_array?(row["sources"]), "#{prefix}: sources must be non-empty")

        Array(row["affected_capabilities"]).each { |id| @findings.add_unless(@capabilities.key?(id), "#{prefix}: unknown capability #{id}") }
        Array(row["sources"]).each do |id|
          @findings.add_unless(@sources.key?(id), "#{prefix}: unknown source #{id}")
          @covered_sources << id
        end
      end
    end

    def check_unused_sources
      used = @covered_sources + @rows.fetch(:capabilities).flat_map { |row| Array(row["sources"]) }
      (@sources.keys - used.uniq).each do |id|
        @findings.add("sources.yaml: source #{id} is not used by coverage, capabilities, or semantics")
      end
    end

    # -- predicates ----------------------------------------------------------

    def non_empty_array?(value)
      value.is_a?(Array) && !value.empty?
    end

    def string_list?(value)
      value.is_a?(Array) && !value.empty? &&
        value.uniq.length == value.length &&
        value.all? { |item| item.is_a?(String) && !item.empty? }
    end
  end
end
