#!/usr/bin/env ruby

require "fileutils"
require "open3"
require "rbconfig"
require "tmpdir"

ROOT = File.expand_path("..", __dir__)
VALIDATOR = File.join(ROOT, "scripts", "validate_integrations.rb")
BUNDLE = File.join(ROOT, "integrations", "google-search-console")
SCHEMA = File.join(ROOT, "schema", "integration-capability.schema.json")

def replace_once(path, before, after)
  content = File.read(path)
  raise "Fixture setup could not find #{before.inspect} in #{path}" unless content.sub!(before, after)

  File.write(path, content)
end

def assert_rejected(name, expected)
  Dir.mktmpdir("gsc-validator-") do |root|
    target_bundle = File.join(root, "integrations", "google-search-console")
    target_schema = File.join(root, "schema")
    FileUtils.mkdir_p(File.dirname(target_bundle))
    FileUtils.mkdir_p(target_schema)
    FileUtils.cp_r(BUNDLE, target_bundle)
    FileUtils.cp(SCHEMA, target_schema)

    yield root

    stdout, stderr, status = Open3.capture3(
      { "INTEGRATION_VALIDATION_ROOT" => root },
      RbConfig.ruby,
      VALIDATOR
    )
    output = "#{stdout}\n#{stderr}"
    raise "#{name}: validator unexpectedly passed" if status.success?
    raise "#{name}: expected #{expected.inspect}, got #{output.inspect}" unless output.include?(expected)
  end
end

def rejection_case(cases, name, expected, &mutation)
  cases << [name, expected, mutation]
end

cases = []

rejection_case(cases, "duplicate capability ID", "Duplicate capability id") do |root|
  path = File.join(root, "integrations", "google-search-console", "capabilities.yaml")
  replace_once(path, "id: GSC-CAP-PROPERTY-GET", "id: GSC-CAP-PROPERTIES-LIST")
end

rejection_case(cases, "duplicate YAML key", "duplicate YAML mapping key") do |root|
  path = File.join(root, "integrations", "google-search-console", "capabilities.yaml")
  replace_once(path, "    name: List accessible properties\n", "    name: List accessible properties\n    name: Duplicate name\n")
end

rejection_case(cases, "unknown source reference", "unknown source GSC-SRC-UNKNOWN") do |root|
  path = File.join(root, "integrations", "google-search-console", "capabilities.yaml")
  replace_once(path, "sources: [GSC-SRC-API, GSC-SRC-AUTH]", "sources: [GSC-SRC-UNKNOWN, GSC-SRC-AUTH]")
end

rejection_case(cases, "missing capability sources", "sources must be a non-empty unique string list") do |root|
  path = File.join(root, "integrations", "google-search-console", "capabilities.yaml")
  replace_once(path, "sources: [GSC-SRC-API, GSC-SRC-AUTH]", "sources: []")
end

rejection_case(cases, "invalid source authority", "invalid authority secondary_summary") do |root|
  path = File.join(root, "integrations", "google-search-console", "sources.yaml")
  replace_once(path, "authority: provider_documentation", "authority: secondary_summary")
end

rejection_case(cases, "invalid OAuth scope", "invalid OAuth scopes https://www.googleapis.com/auth/unknown") do |root|
  path = File.join(root, "integrations", "google-search-console", "capabilities.yaml")
  replace_once(path, "https://www.googleapis.com/auth/webmasters.readonly", "https://www.googleapis.com/auth/unknown")
end

rejection_case(cases, "unapproved mutation", "mutation cannot use approval none") do |root|
  path = File.join(root, "integrations", "google-search-console", "capabilities.yaml")
  replace_once(path, "    approval: exact\n    inputs: [\"Exact property identifier\", \"Approved authenticated principal\"]", "    approval: none\n    inputs: [\"Exact property identifier\", \"Approved authenticated principal\"]")
end

rejection_case(cases, "mutation without rollback", "mutation requires rollback or irreversibility text") do |root|
  path = File.join(root, "integrations", "google-search-console", "capabilities.yaml")
  replace_once(path, "    rollback: \"Delete the same property from the user's set; this does not remove verification tokens\"", "    rollback: \"Not applicable\"")
end

rejection_case(cases, "unknown workflow capability", "unknown capability GSC-CAP-UNKNOWN") do |root|
  path = File.join(root, "integrations", "google-search-console", "workflows.yaml")
  replace_once(path, "GSC-CAP-PROPERTIES-LIST", "GSC-CAP-UNKNOWN")
end

rejection_case(cases, "unknown evaluation capability", "unknown capability GSC-CAP-UNKNOWN") do |root|
  path = File.join(root, "integrations", "google-search-console", "evaluations.yaml")
  replace_once(path, "GSC-CAP-PERFORMANCE-SEARCH", "GSC-CAP-UNKNOWN")
end

rejection_case(cases, "unrouted mutation", "mutation GSC-CAP-ASSOCIATIONS-MANAGE is not routed") do |root|
  path = File.join(root, "integrations", "google-search-console", "workflows.yaml")
  replace_once(path, ", GSC-CAP-ASSOCIATIONS-MANAGE", "")
end

rejection_case(cases, "expired source review", "official-source review expired") do |root|
  path = File.join(root, "integrations", "google-search-console", "sources.yaml")
  replace_once(path, "next_review: 2026-09-13", "next_review: 2026-08-01")
end

cases.each do |name, expected, mutation|
  assert_rejected(name, expected, &mutation)
end

puts "Integration validator negative tests valid: #{cases.length} rejection cases"
