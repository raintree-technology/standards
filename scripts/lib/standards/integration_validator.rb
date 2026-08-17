# frozen_string_literal: true

require "date"
require "json"
require "uri"

require_relative "findings"
require_relative "input_limits"
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
  class GoogleSearchConsoleValidator
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
      return self unless InputLimits.validate(@root, @findings)

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

  # Discovers every manifest-backed integration and applies the common bundle
  # contract. Google Search Console keeps its deeper capability-map checks;
  # provider bundles can add the same artifacts later without
  # changing discovery or audit routing.
  class IntegrationValidator
    MANIFEST_KEYS = %w[version integration id_prefix playbook reviewed_on official_domains informative_domains artifacts features vocabulary skill_routes].freeze
    OPTIONAL_MANIFEST_KEYS = %w[features vocabulary informative_domains].freeze
    REQUIRED_ARTIFACTS = %w[sources workflows evaluations].freeze
    ARTIFACT_NAMES = {
      "sources" => "sources.yaml", "capabilities" => "capabilities.yaml",
      "semantics" => "data-semantics.yaml", "workflows" => "workflows.yaml",
      "evaluations" => "evaluations.yaml"
    }.freeze
    SOURCE_FIELDS = %w[id title url topic authority volatility].freeze
    WORKFLOW_FIELDS = %w[id name trigger sources capabilities steps stop_conditions outputs].freeze
    EVALUATION_FIELDS = %w[id workflow sources capabilities scenario evidence expected prohibited].freeze
    AUTHORITIES = %w[provider_documentation provider_engineering independent_engineering].freeze
    VOLATILITIES = %w[low medium high].freeze
    SKILL_AVAILABILITIES = %w[when_available not_available].freeze

    attr_reader :findings

    def initialize(root, today: Date.today)
      @root = File.expand_path(root)
      @today = today
      @findings = Findings.new
      @manifests = {}
      @summaries = []
      @provider_capabilities = {}
      @provider_mutations = {}
      @provider_routed = Hash.new { |hash, key| hash[key] = [] }
      @provider_workflow_routed = Hash.new { |hash, key| hash[key] = [] }
      @provider_evaluation_routed = Hash.new { |hash, key| hash[key] = [] }
      @provider_used_sources = Hash.new { |hash, key| hash[key] = [] }
    end

    def valid? = @findings.empty?
    def summary_lines = ["Integration bundle valid: #{@summaries.join('; ')}"]

    def artifacts_present?
      manifests = Paths.glob_absolute(@root, File.join("integrations", "*", "manifest.yaml"))
      @findings.add("Missing integration manifests under integrations/") if manifests.empty?
      %w[integration-manifest.schema.json integration-capability.schema.json].each do |name|
        @findings.add("Missing integration schema: schema/#{name}") unless File.file?(File.join(@root, "schema", name))
      end
      manifests.each { |path| load_manifest(path) }
      @manifests.each_value { |entry| check_declared_artifacts(entry) }
      @findings.empty?
    end

    def run
      return self unless InputLimits.validate(@root, @findings)
      artifacts_present? if @manifests.empty?
      return self unless @findings.empty?

      @manifests.each_value do |entry|
        validate_manifest(entry)
        validate_bundle(entry)
        next unless entry[:integration] == GoogleSearchConsoleValidator::INTEGRATION

        deep = GoogleSearchConsoleValidator.new(@root, today: @today)
        if deep.artifacts_present?
          deep.run
          deep.findings.each { |message| @findings.add("google-search-console: #{message}") }
        else
          deep.findings.each { |message| @findings.add("google-search-console: #{message}") }
        end
      end
      self
    end

    private

    def load_manifest(path)
      label = Paths.relative(@root, path)
      document = YamlSource.load_file(path, label, @findings, permitted_classes: [Date])
      integration = document["integration"]
      directory = File.basename(File.dirname(path))
      @findings.add("#{label}: integration must match directory #{directory}") unless integration == directory
      @findings.add("Duplicate integration manifest #{integration}") if @manifests.key?(integration)
      @manifests[integration] = { path: path, dir: File.dirname(path), label: label, document: document, integration: integration }
    end

    def check_declared_artifacts(entry)
      artifacts = entry[:document]["artifacts"]
      unless artifacts.is_a?(Hash)
        @findings.add("#{entry[:label]}: artifacts must be a mapping")
        return
      end
      REQUIRED_ARTIFACTS.each { |kind| @findings.add("#{entry[:label]}: artifacts must declare #{kind}") unless artifacts.key?(kind) }
      artifacts.each do |kind, name|
        @findings.add("#{entry[:label]}: unsupported artifact #{kind}") unless ARTIFACT_NAMES[kind] == name
        path = File.join(entry[:dir], name.to_s)
        @findings.add("Missing integration artifact: #{Paths.relative(@root, path)}") unless File.file?(path)
      end
      if artifacts.key?("capabilities") && !entry[:document]["vocabulary"].is_a?(Hash)
        @findings.add("#{entry[:label]}: capability bundles require vocabulary")
      end
      feature_artifacts = { "capabilities" => "capabilities", "semantics" => "semantics" }
      Array(entry[:document]["features"]).each do |feature|
        artifact = feature_artifacts[feature]
        @findings.add("#{entry[:label]}: feature #{feature} requires artifact #{artifact}") if artifact && !artifacts.key?(artifact)
      end
    end

    def validate_manifest(entry)
      document = entry[:document]
      unknown = document.keys - MANIFEST_KEYS
      required = MANIFEST_KEYS - OPTIONAL_MANIFEST_KEYS
      @findings.add("#{entry[:label]}: unknown fields #{unknown.join(', ')}") unless unknown.empty?
      @findings.add("#{entry[:label]}: missing fields #{(required - document.keys).join(', ')}") unless (required - document.keys).empty?
      schema = JSON.parse(File.read(File.join(@root, "schema", "integration-manifest.schema.json")))
      JsonSchema.validate(document, schema, label: "").each { |message| @findings.add("#{entry[:label]}: #{message}") }
      Array(document["skill_routes"]).each_with_index do |route, index|
        prefix = "#{entry[:label]}: skill_routes[#{index}]"
        next unless route.is_a?(Hash)
        @findings.add("#{prefix}: invalid availability #{route['availability']}") unless SKILL_AVAILABILITIES.include?(route["availability"])
        @findings.add("#{prefix}: skills are review aids, not authority") unless route["authority"] == "review_aid"
      end
      route_names = Array(document["skill_routes"]).filter_map { |route| route["name"] if route.is_a?(Hash) }
      route_names.tally.each { |name, count| @findings.add("#{entry[:label]}: duplicate skill route #{name}") if count > 1 }
    rescue JSON::ParserError => e
      @findings.add("schema/integration-manifest.schema.json: invalid JSON (#{e.message.lines.first.to_s.strip})")
    rescue JsonSchema::UnsupportedKeyword => e
      @findings.add("schema/integration-manifest.schema.json: #{e.message}")
    end

    def validate_bundle(entry)
      docs = {}
      entry[:document].fetch("artifacts", {}).each do |kind, name|
        next unless %w[sources capabilities semantics workflows evaluations].include?(kind)
        docs[kind] = YamlSource.load_file(File.join(entry[:dir], name), name, @findings, permitted_classes: [Date])
        @findings.add("#{entry[:integration]}/#{name}: integration must be #{entry[:integration]}") unless docs[kind]["integration"] == entry[:integration]
      end
      return unless REQUIRED_ARTIFACTS.all? { |kind| docs.key?(kind) }

      unless entry[:integration] == GoogleSearchConsoleValidator::INTEGRATION
        check_provider_top_level(entry, docs)
        check_provider_identity_graph(entry, docs)
      end

      sources = collect_rows(docs["sources"]["sources"], "#{entry[:integration]}/sources.yaml: sources", "id")
      workflows = collect_rows(docs["workflows"]["workflows"], "#{entry[:integration]}/workflows.yaml: workflows", "id")
      evaluations = collect_rows(docs["evaluations"]["evaluations"], "#{entry[:integration]}/evaluations.yaml: evaluations", "id")
      check_provider_sources(entry, docs["sources"], sources)
      if docs.key?("capabilities") && entry[:integration] != GoogleSearchConsoleValidator::INTEGRATION
        check_provider_capabilities(entry, docs, sources)
      end
      check_provider_workflows(entry, workflows, sources)
      check_provider_evaluations(entry, evaluations, workflows, sources)
      capability_count = docs.key?("capabilities") ? Array(docs["capabilities"]["capabilities"]).length : 0
      @summaries << "#{entry[:integration]} (#{sources.length} sources, #{capability_count} capabilities, #{workflows.length} workflows, #{evaluations.length} evaluations)"
    end

    def collect_rows(value, label, key)
      rows = YamlSource.mapping_rows(value, label, @findings)
      rows.each_with_index.each_with_object({}) do |(row, index), result|
        id = row[key]
        @findings.add("#{label}[#{index}]: missing #{key}") if id.to_s.empty?
        @findings.add("#{label}: duplicate #{key} #{id}") if result.key?(id)
        result[id] = row unless id.to_s.empty?
      end
    end

    def check_provider_identity_graph(entry, docs)
      prefix = entry[:document]["id_prefix"].to_s
      sets = {
        "sources" => ["sources", "SRC"], "capabilities" => ["capabilities", "CAP"],
        "semantics" => ["concepts", "SEM"], "workflows" => ["workflows", "WF"],
        "evaluations" => ["evaluations", "EVAL"]
      }
      seen = {}
      sets.each do |kind, (field, segment)|
        next unless docs.key?(kind)
        YamlSource.mapping_rows(docs[kind][field], "#{entry[:integration]}/#{kind}", @findings).each do |row|
          id = row["id"].to_s
          @findings.add("#{entry[:integration]}/#{kind}: ID #{id} must use #{prefix}-#{segment}- prefix") unless id.match?(/\A#{Regexp.escape(prefix)}-#{segment}-[A-Z0-9]+(?:-[A-Z0-9]+)*\z/)
          @findings.add("Duplicate integration ID #{id} across #{seen[id]} and #{kind}") if seen.key?(id)
          seen[id] = kind
        end
      end
    end

    def check_provider_top_level(entry, docs)
      expected = {
        "sources" => %w[version integration reviewed_on scope freshness sources coverage],
        "capabilities" => %w[version integration reviewed_on capabilities],
        "semantics" => %w[version integration reviewed_on concepts],
        "workflows" => %w[version integration workflows],
        "evaluations" => %w[version integration evaluations]
      }
      docs.each do |kind, document|
        next unless expected.key?(kind)
        label = "#{entry[:integration]}/#{entry[:document]['artifacts'][kind]}"
        unknown = document.keys - expected[kind]
        missing = expected[kind] - document.keys
        @findings.add("#{label}: unknown top-level fields #{unknown.join(', ')}") unless unknown.empty?
        @findings.add("#{label}: missing top-level fields #{missing.join(', ')}") unless missing.empty?
        @findings.add("#{label}: version must be 1") unless document["version"] == 1
      end
    end

    def check_provider_sources(entry, document, sources)
      domains = Array(entry[:document]["official_domains"])
      informative_domains = Array(entry[:document]["informative_domains"])
      sources.each_value do |row|
        prefix = "#{entry[:integration]}/sources.yaml: #{row['id']}"
        unknown = row.keys - SOURCE_FIELDS
        @findings.add("#{prefix}: unknown fields #{unknown.join(', ')}") unless unknown.empty?
        missing = SOURCE_FIELDS.select { |field| row[field].to_s.empty? }
        @findings.add("#{prefix}: missing #{missing.join(', ')}") unless missing.empty?
        @findings.add("#{prefix}: invalid authority #{row['authority']}") unless AUTHORITIES.include?(row["authority"])
        @findings.add("#{prefix}: invalid volatility #{row['volatility']}") unless VOLATILITIES.include?(row["volatility"])
        begin
          uri = URI.parse(row["url"].to_s)
          allowed_domains = row["authority"] == "independent_engineering" ? informative_domains : domains
          allowed = uri.scheme == "https" && allowed_domains.any? { |domain| uri.host == domain || uri.host&.end_with?(".#{domain}") }
          message = row["authority"] == "independent_engineering" ? "URL must use an allowlisted informative HTTPS domain" : "URL must use an official HTTPS domain"
          @findings.add("#{prefix}: #{message}") unless allowed
        rescue URI::InvalidURIError
          @findings.add("#{prefix}: URL must use a valid allowlisted HTTPS domain")
        end
      end

      Array(document["coverage"]).each do |row|
        next unless row.is_a?(Hash) && row["classification"] == "mapped"

        refs = Array(row["sources"])
        next if refs.any? { |id| sources[id]&.fetch("authority", nil) == "provider_documentation" }

        @findings.add("#{entry[:integration]}/sources.yaml: coverage #{row['surface']} requires provider documentation; engineering sources are informative")
      end
      freshness = document["freshness"]
      valid = freshness.is_a?(Hash) && freshness["cadence_days"].is_a?(Integer) && freshness["cadence_days"].positive? && freshness["next_review"].is_a?(Date) && non_empty_array?(freshness["event_triggers"])
      @findings.add("#{entry[:integration]}/sources.yaml: invalid freshness contract") unless valid
      return unless valid
      reviewed = document["reviewed_on"]
      @findings.add("#{entry[:integration]}/sources.yaml: next_review must be after reviewed_on") unless reviewed.is_a?(Date) && freshness["next_review"] > reviewed
      @findings.add("#{entry[:integration]}/sources.yaml: official-source review expired on #{freshness['next_review']}") if @today > freshness["next_review"]
    end

    def check_provider_capabilities(entry, docs, sources)
      integration = entry[:integration]
      capabilities = collect_rows(docs["capabilities"]["capabilities"], "#{integration}/capabilities.yaml: capabilities", "id")
      semantics = docs.key?("semantics") ? collect_rows(docs["semantics"]["concepts"], "#{integration}/data-semantics.yaml: concepts", "id") : {}
      coverage = collect_rows(docs["sources"]["coverage"], "#{integration}/sources.yaml: coverage", "surface")
      vocabulary = entry[:document]["vocabulary"] || {}
      interfaces = Array(vocabulary["interfaces"])
      roles = Array(vocabulary["property_roles"])
      scopes = Array(vocabulary["oauth_scopes"])
      prefix_pattern = /\A#{Regexp.escape(entry[:document]['id_prefix'].to_s)}-CAP-[A-Z0-9]+(?:-[A-Z0-9]+)*\z/

      schema = JSON.parse(File.read(File.join(@root, "schema", "integration-capability.schema.json")))
      JsonSchema.validate(docs["capabilities"], schema, label: "").each { |message| @findings.add("#{integration}/capabilities.yaml: #{message}") }

      capabilities.each_value do |row|
        label = "#{integration}/capabilities.yaml: #{row['id']}"
        @findings.add("#{label}: ID must use #{entry[:document]['id_prefix']}-CAP- prefix") unless row["id"].to_s.match?(prefix_pattern)
        @findings.add("#{label}: invalid interface #{row['interface']}") unless interfaces.include?(row["interface"])
        @findings.add("#{label}: invalid availability #{row['availability']}") unless GoogleSearchConsoleValidator::AVAILABILITIES.include?(row["availability"])
        @findings.add("#{label}: invalid effect #{row['effect']}") unless GoogleSearchConsoleValidator::EFFECTS.include?(row["effect"])
        @findings.add("#{label}: invalid approval #{row['approval']}") unless GoogleSearchConsoleValidator::APPROVALS.include?(row["approval"])
        access = row["access"]
        if access.is_a?(Hash)
          invalid_roles = Array(access["property_roles"]) - roles
          invalid_scopes = Array(access["oauth_scopes"]) - scopes
          @findings.add("#{label}: invalid property roles #{invalid_roles.join(', ')}") unless invalid_roles.empty?
          @findings.add("#{label}: invalid OAuth scopes #{invalid_scopes.join(', ')}") unless invalid_scopes.empty?
        end
        Array(row["data_semantics"]).each { |id| @findings.add("#{label}: unknown semantic #{id}") unless semantics.key?(id) }
        Array(row["sources"]).each do |id|
          @findings.add("#{label}: unknown source #{id}") unless sources.key?(id)
          @provider_used_sources[integration] << id
        end
        unless Array(row["sources"]).any? { |id| sources[id]&.fetch("authority", nil) == "provider_documentation" }
          @findings.add("#{label}: requires provider documentation; engineering sources are informative")
        end
        if GoogleSearchConsoleValidator::MUTATING_EFFECTS.include?(row["effect"])
          @findings.add("#{label}: mutation cannot use approval none") if row["approval"] == "none"
          @findings.add("#{label}: mutation requires rollback or irreversibility text") if row["rollback"].to_s.empty? || row["rollback"] == "Not applicable"
        end
        if row["effect"] == "mutate_high_impact" && !%w[exact human_only].include?(row["approval"])
          @findings.add("#{label}: high-impact mutation requires exact or human_only approval")
        end
      end

      semantics.each_value do |row|
        label = "#{integration}/data-semantics.yaml: #{row['id']}"
        unknown = row.keys - %w[id name definition cautions sources]
        @findings.add("#{label}: unknown fields #{unknown.join(', ')}") unless unknown.empty?
        %w[name definition].each { |field| @findings.add("#{label}: missing #{field}") if row[field].to_s.empty? }
        @findings.add("#{label}: cautions must be non-empty") unless non_empty_array?(row["cautions"])
        @findings.add("#{label}: sources must be non-empty") unless non_empty_array?(row["sources"])
        Array(row["sources"]).each do |id|
          @findings.add("#{label}: unknown source #{id}") unless sources.key?(id)
          @provider_used_sources[integration] << id
        end
      end

      covered = []
      coverage.each_value do |row|
        label = "#{integration}/sources.yaml: coverage #{row['surface']}"
        unknown = row.keys - %w[surface classification capabilities sources rationale]
        @findings.add("#{label}: unknown fields #{unknown.join(', ')}") unless unknown.empty?
        @findings.add("#{label}: invalid classification #{row['classification']}") unless GoogleSearchConsoleValidator::CLASSIFICATIONS.include?(row["classification"])
        @findings.add("#{label}: sources must be non-empty") unless non_empty_array?(row["sources"])
        if %w[adjacent legacy excluded].include?(row["classification"]) && row["rationale"].to_s.empty?
          @findings.add("#{label}: #{row['classification']} surface requires rationale")
        elsif row["classification"] == "mapped" && !non_empty_array?(row["capabilities"])
          @findings.add("#{label}: mapped surface requires capabilities")
        end
        Array(row["capabilities"]).each do |id|
          @findings.add("#{label}: unknown capability #{id}") unless capabilities.key?(id)
          covered << id
        end
        Array(row["sources"]).each do |id|
          @findings.add("#{label}: unknown source #{id}") unless sources.key?(id)
          @provider_used_sources[integration] << id
        end
      end
      (capabilities.keys - covered.uniq).each { |id| @findings.add("#{integration}/sources.yaml: zero-gap ledger does not classify capability #{id}") }
      @provider_capabilities[integration] = capabilities
      @provider_mutations[integration] = capabilities.values.select { |row| GoogleSearchConsoleValidator::ROUTED_EFFECTS.include?(row["effect"]) }.map { |row| row["id"] }
    rescue JSON::ParserError => e
      @findings.add("schema/integration-capability.schema.json: invalid JSON (#{e.message.lines.first.to_s.strip})")
    rescue JsonSchema::UnsupportedKeyword => e
      @findings.add("schema/integration-capability.schema.json: #{e.message}")
    end

    def check_provider_workflows(entry, workflows, sources)
      workflows.each_value do |row|
        prefix = "#{entry[:integration]}/workflows.yaml: #{row['id']}"
        unknown = row.keys - WORKFLOW_FIELDS
        @findings.add("#{prefix}: unknown fields #{unknown.join(', ')}") unless unknown.empty?
        %w[name trigger].each { |field| @findings.add("#{prefix}: missing #{field}") if row[field].to_s.empty? }
        required_lists = %w[steps stop_conditions outputs]
        required_lists << "sources" unless entry[:integration] == GoogleSearchConsoleValidator::INTEGRATION
        required_lists << "capabilities" if @provider_capabilities.key?(entry[:integration])
        required_lists.each { |field| @findings.add("#{prefix}: #{field} must be non-empty") unless non_empty_array?(row[field]) }
        Array(row["sources"]).each { |id| @findings.add("#{prefix}: unknown source #{id}") unless sources.key?(id) }
        Array(row["sources"]).each { |id| @provider_used_sources[entry[:integration]] << id }
        unless entry[:integration] == GoogleSearchConsoleValidator::INTEGRATION
          Array(row["capabilities"]).each do |id|
            @findings.add("#{prefix}: unknown capability #{id}") unless @provider_capabilities.fetch(entry[:integration], {}).key?(id)
            @provider_routed[entry[:integration]] << id
            @provider_workflow_routed[entry[:integration]] << id
          end
        end
      end
    end

    def check_provider_evaluations(entry, evaluations, workflows, sources)
      evaluations.each_value do |row|
        prefix = "#{entry[:integration]}/evaluations.yaml: #{row['id']}"
        unknown = row.keys - EVALUATION_FIELDS
        @findings.add("#{prefix}: unknown fields #{unknown.join(', ')}") unless unknown.empty?
        %w[scenario expected prohibited].each { |field| @findings.add("#{prefix}: missing #{field}") if row[field].to_s.empty? }
        @findings.add("#{prefix}: evidence must be non-empty") unless non_empty_array?(row["evidence"])
        unless entry[:integration] == GoogleSearchConsoleValidator::INTEGRATION
          @findings.add("#{prefix}: sources must be non-empty") unless non_empty_array?(row["sources"])
        end
        if @provider_capabilities.key?(entry[:integration]) && !non_empty_array?(row["capabilities"])
          @findings.add("#{prefix}: capabilities must be non-empty")
        end
        @findings.add("#{prefix}: unknown workflow #{row['workflow']}") unless workflows.key?(row["workflow"])
        Array(row["sources"]).each { |id| @findings.add("#{prefix}: unknown source #{id}") unless sources.key?(id) }
        Array(row["sources"]).each { |id| @provider_used_sources[entry[:integration]] << id }
        unless entry[:integration] == GoogleSearchConsoleValidator::INTEGRATION
          Array(row["capabilities"]).each do |id|
            @findings.add("#{prefix}: unknown capability #{id}") unless @provider_capabilities.fetch(entry[:integration], {}).key?(id)
            @provider_routed[entry[:integration]] << id
            @provider_evaluation_routed[entry[:integration]] << id
          end
        end
      end
      return if entry[:integration] == GoogleSearchConsoleValidator::INTEGRATION

      integration = entry[:integration]
      @provider_capabilities.fetch(integration, {}).each_key do |id|
        @findings.add("#{integration}/capabilities.yaml: capability #{id} is not routed through a workflow") unless @provider_workflow_routed[integration].include?(id)
        @findings.add("#{integration}/capabilities.yaml: capability #{id} is not routed through an evaluation") unless @provider_evaluation_routed[integration].include?(id)
      end
      Array(@provider_mutations[integration]).each do |id|
        @findings.add("#{integration}/capabilities.yaml: mutation #{id} is not routed through a workflow or evaluation") unless @provider_routed[integration].include?(id)
      end
      if Array(entry[:document]["features"]).include?("source_usage")
        unused = sources.keys - @provider_used_sources[integration].uniq
        unused.each { |id| @findings.add("#{integration}/sources.yaml: source #{id} is not used") }
      end
    end

    def non_empty_array?(value) = value.is_a?(Array) && !value.empty?
  end
end
