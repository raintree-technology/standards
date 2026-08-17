#!/usr/bin/env ruby

require "date"
require "json"
require "yaml"
require_relative "yaml_validation"

ROOT = if ENV["INTEGRATION_VALIDATION_ROOT"].to_s.empty?
         File.expand_path("..", __dir__)
       else
         File.expand_path(ENV.fetch("INTEGRATION_VALIDATION_ROOT"))
       end
BUNDLE_DIR = File.join(ROOT, "integrations", "google-search-console")
SCHEMA = File.join(ROOT, "schema", "integration-capability.schema.json")

FILES = {
  sources: File.join(BUNDLE_DIR, "sources.yaml"),
  capabilities: File.join(BUNDLE_DIR, "capabilities.yaml"),
  semantics: File.join(BUNDLE_DIR, "data-semantics.yaml"),
  workflows: File.join(BUNDLE_DIR, "workflows.yaml"),
  evaluations: File.join(BUNDLE_DIR, "evaluations.yaml")
}.freeze

errors = []

FILES.each_value do |path|
  errors << "Missing integration artifact: #{path.delete_prefix(ROOT + "/")}" unless File.file?(path)
end
errors << "Missing integration schema: schema/integration-capability.schema.json" unless File.file?(SCHEMA)

unless errors.empty?
  warn errors.join("\n")
  exit 1
end

begin
  JSON.parse(File.read(SCHEMA))
rescue JSON::ParserError => e
  errors << "schema/integration-capability.schema.json: invalid JSON: #{e.message}"
end

load_yaml = lambda do |path|
  YamlValidation.find_duplicate_keys(Psych.parse_stream(File.read(path)), path.delete_prefix(ROOT + "/"), errors)
  YAML.safe_load(File.read(path), permitted_classes: [Date], aliases: false)
rescue Psych::Exception => e
  errors << "#{path.delete_prefix(ROOT + "/")}: invalid YAML: #{e.message}"
  {}
end

documents = FILES.transform_values { |path| load_yaml.call(path) }
expected_top_level_keys = {
  sources: %w[version integration reviewed_on scope freshness sources change_watch coverage],
  capabilities: %w[version integration reviewed_on capabilities],
  semantics: %w[version integration reviewed_on concepts],
  workflows: %w[version integration workflows],
  evaluations: %w[version integration evaluations]
}.freeze
documents.each do |kind, document|
  relative = FILES.fetch(kind).delete_prefix(ROOT + "/")
  errors << "#{relative}: version must be 1" unless document["version"] == 1
  errors << "#{relative}: integration must be google-search-console" unless document["integration"] == "google-search-console"
  unknown = document.keys - expected_top_level_keys.fetch(kind)
  missing = expected_top_level_keys.fetch(kind) - document.keys
  errors << "#{relative}: unknown top-level fields #{unknown.join(', ')}" unless unknown.empty?
  errors << "#{relative}: missing top-level fields #{missing.join(', ')}" unless missing.empty?
end

source_rows = Array(documents[:sources]["sources"])
capability_rows = Array(documents[:capabilities]["capabilities"])
semantic_rows = Array(documents[:semantics]["concepts"])
workflow_rows = Array(documents[:workflows]["workflows"])
evaluation_rows = Array(documents[:evaluations]["evaluations"])
coverage_rows = Array(documents[:sources]["coverage"])
watch_rows = Array(documents[:sources]["change_watch"])

collect = lambda do |rows, field, label|
  found = {}
  rows.each_with_index do |row, index|
    value = row[field]
    if value.to_s.empty?
      errors << "#{label}[#{index}]: missing #{field}"
    elsif found.key?(value)
      errors << "Duplicate #{label} #{field} #{value}"
    else
      found[value] = row
    end
  end
  found
end

sources = collect.call(source_rows, "id", "source")
capabilities = collect.call(capability_rows, "id", "capability")
semantics = collect.call(semantic_rows, "id", "semantic")
workflows = collect.call(workflow_rows, "id", "workflow")
evaluations = collect.call(evaluation_rows, "id", "evaluation")
coverage = collect.call(coverage_rows, "surface", "coverage")
change_watch = collect.call(watch_rows, "id", "change watch")

all_ids = {}
[
  [sources, "source"], [capabilities, "capability"], [semantics, "semantic"],
  [workflows, "workflow"], [evaluations, "evaluation"], [change_watch, "change watch"]
].each do |mapping, label|
  mapping.each_key do |id|
    errors << "Duplicate integration ID #{id} across #{all_ids[id]} and #{label}" if all_ids.key?(id)
    all_ids[id] = label
  end
end

required_capability_fields = %w[
  id name interface availability access effect approval inputs outputs data_semantics limits
  limitations verification idempotency rollback sources
].freeze
interfaces = %w[search_console_api search_console_ui bigquery_export email_notification indexing_api external_google_tool].freeze
availabilities = %w[current adjacent legacy unavailable].freeze
effects = %w[observe diagnose mutate_reversible mutate_high_impact human_only].freeze
approvals = %w[none bounded exact human_only].freeze
roles = %w[none restricted_user full_user owner verified_owner google_cloud_role].freeze
oauth_scopes = %w[
  https://www.googleapis.com/auth/webmasters.readonly
  https://www.googleapis.com/auth/webmasters
  https://www.googleapis.com/auth/indexing
].freeze

capability_rows.each_with_index do |row, index|
  prefix = "capabilities.yaml: capability[#{index}] #{row['id']}"
  unknown_fields = row.keys - required_capability_fields
  errors << "#{prefix}: unknown fields #{unknown_fields.join(', ')}" unless unknown_fields.empty?
  required_capability_fields.each do |field|
    value = row[field]
    errors << "#{prefix}: missing #{field}" if value.nil? || value == "" || (value.respond_to?(:empty?) && value.empty? && !%w[oauth_scopes property_roles].include?(field))
  end
  errors << "#{prefix}: invalid interface #{row['interface']}" unless interfaces.include?(row["interface"])
  errors << "#{prefix}: invalid availability #{row['availability']}" unless availabilities.include?(row["availability"])
  errors << "#{prefix}: invalid effect #{row['effect']}" unless effects.include?(row["effect"])
  errors << "#{prefix}: invalid approval #{row['approval']}" unless approvals.include?(row["approval"])

  access = row["access"]
  unless access.is_a?(Hash) && access["oauth_scopes"].is_a?(Array) && access["property_roles"].is_a?(Array)
    errors << "#{prefix}: access requires oauth_scopes and property_roles arrays"
  else
    unknown_access_fields = access.keys - %w[oauth_scopes property_roles]
    errors << "#{prefix}: unknown access fields #{unknown_access_fields.join(', ')}" unless unknown_access_fields.empty?
    errors << "#{prefix}: property_roles must declare at least one role" if access["property_roles"].empty?
    unknown_roles = access["property_roles"] - roles
    errors << "#{prefix}: invalid property roles #{unknown_roles.join(', ')}" unless unknown_roles.empty?
    unknown_scopes = access["oauth_scopes"] - oauth_scopes
    errors << "#{prefix}: invalid OAuth scopes #{unknown_scopes.join(', ')}" unless unknown_scopes.empty?
  end

  %w[inputs outputs data_semantics limitations verification sources].each do |field|
    values = row[field]
    errors << "#{prefix}: #{field} must be a non-empty unique string list" unless values.is_a?(Array) && !values.empty? && values.uniq.length == values.length && values.all? { |value| value.is_a?(String) && !value.empty? }
  end

  limit_dimensions = %w[quotas latency sampling privacy_suppression aggregation completeness operational]
  limits = row["limits"]
  if !limits.is_a?(Hash) || limits.keys.sort != limit_dimensions.sort
    errors << "#{prefix}: limits must declare exactly #{limit_dimensions.join(', ')}"
  else
    limit_dimensions.each do |dimension|
      values = limits[dimension]
      errors << "#{prefix}: limits.#{dimension} must be a non-empty unique string list" unless values.is_a?(Array) && !values.empty? && values.uniq.length == values.length && values.all? { |value| value.is_a?(String) && !value.empty? }
    end
  end

  Array(row["sources"]).each do |source_id|
    errors << "#{prefix}: unknown source #{source_id}" unless sources.key?(source_id)
  end

  if %w[mutate_reversible mutate_high_impact].include?(row["effect"])
    errors << "#{prefix}: mutation cannot use approval none" if row["approval"] == "none"
    errors << "#{prefix}: mutation requires verification" if Array(row["verification"]).empty?
    errors << "#{prefix}: mutation requires rollback or irreversibility text" if row["rollback"].to_s.empty? || row["rollback"] == "Not applicable"
  end
  if row["effect"] == "mutate_high_impact" && !%w[exact human_only].include?(row["approval"])
    errors << "#{prefix}: high-impact mutation requires exact or human_only approval"
  end
  if %w[observe diagnose].include?(row["effect"]) && row["approval"] != "none"
    errors << "#{prefix}: observe and diagnose effects require approval none"
  end
  if row["effect"] == "human_only" && row["approval"] != "human_only"
    errors << "#{prefix}: human_only effect requires human_only approval"
  end
end

classifications = %w[mapped adjacent legacy excluded].freeze
covered_capabilities = []
covered_sources = []
coverage_rows.each_with_index do |row, index|
  prefix = "sources.yaml: coverage[#{index}] #{row['surface']}"
  unknown_fields = row.keys - %w[surface classification capabilities sources rationale]
  errors << "#{prefix}: unknown fields #{unknown_fields.join(', ')}" unless unknown_fields.empty?
  classification = row["classification"]
  errors << "#{prefix}: invalid classification #{classification}" unless classifications.include?(classification)
  caps = Array(row["capabilities"])
  refs = Array(row["sources"])
  errors << "#{prefix}: sources must be non-empty" if refs.empty?
  if %w[adjacent legacy excluded].include?(classification)
    errors << "#{prefix}: #{classification} surface requires rationale" if row["rationale"].to_s.empty?
  else
    errors << "#{prefix}: non-excluded surface requires capabilities" if caps.empty?
  end
  caps.each do |id|
    errors << "#{prefix}: unknown capability #{id}" unless capabilities.key?(id)
  end
  refs.each do |id|
    errors << "#{prefix}: unknown source #{id}" unless sources.key?(id)
  end
  covered_capabilities.concat(caps)
  covered_sources.concat(refs)
end

(capabilities.keys - covered_capabilities.uniq).each do |id|
  errors << "sources.yaml: zero-gap ledger does not classify capability #{id}"
end

semantic_rows.each_with_index do |row, index|
  prefix = "data-semantics.yaml: concept[#{index}] #{row['id']}"
  unknown_fields = row.keys - %w[id name definition cautions sources]
  errors << "#{prefix}: unknown fields #{unknown_fields.join(', ')}" unless unknown_fields.empty?
  %w[name definition].each { |field| errors << "#{prefix}: missing #{field}" if row[field].to_s.empty? }
  errors << "#{prefix}: cautions must be non-empty" unless row["cautions"].is_a?(Array) && !row["cautions"].empty?
  Array(row["sources"]).each do |id|
    errors << "#{prefix}: unknown source #{id}" unless sources.key?(id)
    covered_sources << id
  end
end

workflow_rows.each_with_index do |row, index|
  prefix = "workflows.yaml: workflow[#{index}] #{row['id']}"
  unknown_fields = row.keys - %w[id name trigger capabilities steps stop_conditions outputs]
  errors << "#{prefix}: unknown fields #{unknown_fields.join(', ')}" unless unknown_fields.empty?
  %w[name trigger].each { |field| errors << "#{prefix}: missing #{field}" if row[field].to_s.empty? }
  %w[capabilities steps stop_conditions outputs].each do |field|
    errors << "#{prefix}: #{field} must be non-empty" unless row[field].is_a?(Array) && !row[field].empty?
  end
  Array(row["capabilities"]).each do |id|
    errors << "#{prefix}: unknown capability #{id}" unless capabilities.key?(id)
  end
end

evaluation_rows.each_with_index do |row, index|
  prefix = "evaluations.yaml: evaluation[#{index}] #{row['id']}"
  unknown_fields = row.keys - %w[id workflow capabilities scenario evidence expected prohibited]
  errors << "#{prefix}: unknown fields #{unknown_fields.join(', ')}" unless unknown_fields.empty?
  %w[scenario expected prohibited].each { |field| errors << "#{prefix}: missing #{field}" if row[field].to_s.empty? }
  errors << "#{prefix}: evidence must be non-empty" unless row["evidence"].is_a?(Array) && !row["evidence"].empty?
  errors << "#{prefix}: unknown workflow #{row['workflow']}" unless workflows.key?(row["workflow"])
  Array(row["capabilities"]).each do |id|
    errors << "#{prefix}: unknown capability #{id}" unless capabilities.key?(id)
  end
end

mutation_ids = capability_rows.select { |row| %w[mutate_reversible mutate_high_impact human_only].include?(row["effect"]) }.map { |row| row["id"] }
routed_capability_ids = workflow_rows.flat_map { |row| Array(row["capabilities"]) } + evaluation_rows.flat_map { |row| Array(row["capabilities"]) }
(mutation_ids - routed_capability_ids.uniq).each do |id|
  errors << "capabilities.yaml: mutation #{id} is not routed through a workflow or evaluation"
end

source_rows.each_with_index do |row, index|
  prefix = "sources.yaml: source[#{index}] #{row['id']}"
  unknown_fields = row.keys - %w[id title url topic authority volatility]
  errors << "#{prefix}: unknown fields #{unknown_fields.join(', ')}" unless unknown_fields.empty?
  %w[title url topic authority volatility].each { |field| errors << "#{prefix}: missing #{field}" if row[field].to_s.empty? }
  errors << "#{prefix}: invalid authority #{row['authority']}" unless %w[provider_documentation].include?(row["authority"])
  errors << "#{prefix}: invalid volatility #{row['volatility']}" unless %w[low medium high].include?(row["volatility"])
  errors << "#{prefix}: URL must use official Google HTTPS documentation" unless row["url"].to_s.match?(%r{\Ahttps://(?:developers\.google\.com|support\.google\.com|status\.search\.google\.com|trends\.google\.com)/})
end

freshness = documents[:sources]["freshness"]
unless freshness.is_a?(Hash) && freshness["cadence_days"].is_a?(Integer) && freshness["cadence_days"].positive? && freshness["next_review"].is_a?(Date) && freshness["event_triggers"].is_a?(Array) && !freshness["event_triggers"].empty?
  errors << "sources.yaml: freshness requires a positive cadence_days, next_review date, and non-empty event_triggers"
else
  reviewed_on = documents[:sources]["reviewed_on"]
  next_review = freshness["next_review"]
  if reviewed_on.is_a?(Date)
    errors << "sources.yaml: freshness next_review must be after reviewed_on" unless next_review > reviewed_on
    errors << "sources.yaml: freshness next_review exceeds cadence_days" if next_review > reviewed_on + freshness["cadence_days"]
  end
  errors << "sources.yaml: official-source review expired on #{next_review}" if Date.today > next_review
end

watch_statuses = %w[announced_deprecation limited_rollout provider_change].freeze
watch_rows.each_with_index do |row, index|
  prefix = "sources.yaml: change_watch[#{index}] #{row['id']}"
  unknown_fields = row.keys - %w[id status effective affected_capabilities action sources]
  errors << "#{prefix}: unknown fields #{unknown_fields.join(', ')}" unless unknown_fields.empty?
  errors << "#{prefix}: invalid status #{row['status']}" unless watch_statuses.include?(row["status"])
  %w[effective action].each { |field| errors << "#{prefix}: missing #{field}" if row[field].to_s.empty? }
  errors << "#{prefix}: affected_capabilities must be non-empty" unless row["affected_capabilities"].is_a?(Array) && !row["affected_capabilities"].empty?
  errors << "#{prefix}: sources must be non-empty" unless row["sources"].is_a?(Array) && !row["sources"].empty?
  Array(row["affected_capabilities"]).each { |id| errors << "#{prefix}: unknown capability #{id}" unless capabilities.key?(id) }
  Array(row["sources"]).each do |id|
    errors << "#{prefix}: unknown source #{id}" unless sources.key?(id)
    covered_sources << id
  end
end

used_sources = covered_sources + capability_rows.flat_map { |row| Array(row["sources"]) }
(sources.keys - used_sources.uniq).each do |id|
  errors << "sources.yaml: source #{id} is not used by coverage, capabilities, or semantics"
end

if errors.empty?
  puts "Integration bundle valid: #{capabilities.length} capabilities, #{coverage.length} coverage surfaces, #{workflows.length} workflows, #{evaluations.length} evaluations, #{change_watch.length} change watches"
else
  warn errors.join("\n")
  exit 1
end
