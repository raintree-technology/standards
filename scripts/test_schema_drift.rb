#!/usr/bin/env ruby
# frozen_string_literal: true

# Asserts that the JSON Schemas and the handwritten Ruby validators still agree.
#
# Both now enforce the bundle, which is what makes drift dangerous: a value
# allowed by one and rejected by the other produces a confusing failure, and a
# value both stopped checking produces none at all. These cases compare the
# schemas' enumerations, required fields, and patterns against the constants the
# validators use, so a change to either side fails here until both are updated.

require "json"

require_relative "lib/standards"
require_relative "lib/standards/catalog_validator"
require_relative "lib/standards/integration_validator"

ROOT = File.expand_path("..", __dir__)
failures = []
checks = 0

def load_schema(name)
  JSON.parse(File.read(File.join(ROOT, "schema", name)))
end

def check(failures, description)
  expected, actual = yield
  return if expected == actual

  failures << "#{description}: schema has #{expected.inspect}, validator has #{actual.inspect}"
end

standard = load_schema("standard.schema.json")
integration = load_schema("integration-capability.schema.json")
capability = integration.fetch("$defs").fetch("capability")

# -- standard.schema.json ----------------------------------------------------

checks += 1
check(failures, "standard.schema.json required front matter") do
  [standard.fetch("required").sort, Standards::CatalogValidator::REQUIRED_FRONT_MATTER.sort]
end

{
  "type" => Standards::CatalogValidator::DOCUMENT_TYPES,
  "status" => Standards::CatalogValidator::DOCUMENT_STATUSES,
  "governance_status" => Standards::CatalogValidator::GOVERNANCE_STATUSES
}.each do |field, constant|
  checks += 1
  check(failures, "standard.schema.json #{field} enum") do
    [standard.fetch("properties").fetch(field).fetch("enum").sort, constant.sort]
  end
end

checks += 1
check(failures, "standard.schema.json id pattern") do
  [standard.fetch("properties").fetch("id").fetch("pattern"), Standards::CatalogValidator::DOCUMENT_ID_PATTERN.source.gsub(/\\A|\\z/) { |anchor| anchor == "\\A" ? "^" : "$" }]
end

# The release rule must stay in $defs/releaseGate. If it moves back into the
# always-applied schema, every unverified stable document fails an ordinary run.
checks += 1
if standard.key?("allOf")
  failures << "standard.schema.json: release-time rules must live in $defs/releaseGate, not in a top-level allOf"
end

checks += 1
gate = standard.dig("$defs", "releaseGate")
if gate.nil?
  failures << "standard.schema.json: $defs/releaseGate is missing; the release gate has nothing to apply"
elsif gate.dig("if", "properties", "status", "const") != "stable" || !Array(gate.dig("then", "required")).include?("verified")
  failures << "standard.schema.json: $defs/releaseGate no longer expresses 'stable documents require verified'"
end

# -- integration-capability.schema.json --------------------------------------

checks += 1
check(failures, "integration schema required capability fields") do
  [capability.fetch("required").sort, Standards::IntegrationValidator::CAPABILITY_FIELDS.sort]
end

checks += 1
check(failures, "integration schema capability properties") do
  [capability.fetch("properties").keys.sort, Standards::IntegrationValidator::CAPABILITY_FIELDS.sort]
end

{
  "interface" => Standards::IntegrationValidator::INTERFACES,
  "availability" => Standards::IntegrationValidator::AVAILABILITIES,
  "effect" => Standards::IntegrationValidator::EFFECTS,
  "approval" => Standards::IntegrationValidator::APPROVALS
}.each do |field, constant|
  checks += 1
  check(failures, "integration schema #{field} enum") do
    [capability.fetch("properties").fetch(field).fetch("enum").sort, constant.sort]
  end
end

checks += 1
check(failures, "integration schema OAuth scopes") do
  [
    integration.dig("$defs", "access", "properties", "oauth_scopes", "items", "enum").sort,
    Standards::IntegrationValidator::OAUTH_SCOPES.sort
  ]
end

checks += 1
check(failures, "integration schema property roles") do
  [
    integration.dig("$defs", "access", "properties", "property_roles", "items", "enum").sort,
    Standards::IntegrationValidator::ROLES.sort
  ]
end

checks += 1
check(failures, "integration schema limit dimensions") do
  [
    integration.dig("$defs", "limits", "required").sort,
    Standards::IntegrationValidator::LIMIT_DIMENSIONS.sort
  ]
end

checks += 1
check(failures, "integration schema top-level required fields") do
  [integration.fetch("required").sort, Standards::IntegrationValidator::TOP_LEVEL_KEYS.fetch(:capabilities).sort]
end

# -- every schema keyword must be one this repository can enforce -------------

# The subset validator raises on keywords it does not implement. Walking both
# schemas here means an unenforceable keyword fails in this test rather than
# only when a document happens to exercise that branch.
def walk_keywords(node, seen)
  case node
  when Hash
    node.each do |key, value|
      seen << key unless key.start_with?("__")
      walk_keywords(value, seen)
    end
  when Array
    node.each { |item| walk_keywords(item, seen) }
  end
  seen
end

known = Standards::JsonSchema::ANNOTATIONS + Standards::JsonSchema::ASSERTIONS
[["standard.schema.json", standard], ["integration-capability.schema.json", integration]].each do |name, schema|
  checks += 1
  used = walk_keywords(schema, []).uniq.select { |key| key.start_with?("$") || known.include?(key) }
  unsupported = used - known
  failures << "#{name}: uses JSON Schema keyword(s) #{unsupported.join(', ')} that Standards::JsonSchema cannot enforce" unless unsupported.empty?
end

if failures.empty?
  puts "Schema drift checks valid: #{checks} comparisons"
  exit Standards::EXIT_SUCCESS
end

failures.each { |message| warn message }
warn "Schema drift: #{failures.length} of #{checks} comparisons failed"
exit Standards::EXIT_INVALID
