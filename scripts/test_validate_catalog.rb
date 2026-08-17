#!/usr/bin/env ruby

require "fileutils"
require "open3"
require "rbconfig"
require "tmpdir"

ROOT = File.expand_path("..", __dir__)
VALIDATOR = File.join(ROOT, "scripts", "validate_catalog.rb")

def replace_once(path, before, after)
  content = File.read(path)
  raise "Fixture setup could not find #{before.inspect} in #{path}" unless content.sub!(before, after)

  File.write(path, content)
end

def copy_repository(target)
  Dir.children(ROOT).each do |name|
    next if name == ".git"

    FileUtils.cp_r(File.join(ROOT, name), File.join(target, name))
  end
end

def assert_rejected(name, expected)
  Dir.mktmpdir("catalog-validator-") do |root|
    copy_repository(root)
    yield root

    stdout, stderr, status = Open3.capture3(
      { "CATALOG_VALIDATION_ROOT" => root },
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

rejection_case(cases, "invalid catalog YAML", "catalog.yaml: invalid YAML") do |root|
  path = File.join(root, "catalog.yaml")
  replace_once(path, "version: 1\n", "version: [\n")
end

rejection_case(cases, "duplicate catalog key", "duplicate YAML mapping key \"version\"") do |root|
  path = File.join(root, "catalog.yaml")
  replace_once(path, "version: 1\n", "version: 1\nversion: 1\n")
end

rejection_case(cases, "invalid catalog section", "catalog.yaml: patterns must be a list") do |root|
  path = File.join(root, "catalog.yaml")
  replace_once(path, "patterns: []\n", "patterns: invalid\n")
end

rejection_case(cases, "invalid catalog update date", "catalog.yaml: updated must be an ISO 8601 date") do |root|
  path = File.join(root, "catalog.yaml")
  replace_once(path, "updated: 2026-08-16\n", "updated: invalid\n")
end

rejection_case(cases, "invalid catalog entry", "catalog.yaml: governance[0] must be a mapping") do |root|
  path = File.join(root, "catalog.yaml")
  replace_once(path, "  - path: governance/authority.md\n", "  - invalid\n")
end

rejection_case(cases, "duplicate front-matter key", "duplicate YAML mapping key \"title\"") do |root|
  path = File.join(root, "CODE_OF_CONDUCT.md")
  replace_once(path, "title: Code of Conduct\n", "title: Code of Conduct\ntitle: Duplicate title\n")
end

rejection_case(cases, "invalid governed front matter", "invalid YAML front matter") do |root|
  path = File.join(root, "foundations", "accessibility.md")
  replace_once(path, "id: FND-ACCESSIBILITY\n", "id: [\n")
end

rejection_case(cases, "non-mapping front matter", "YAML front matter must be a mapping") do |root|
  path = File.join(root, "CODE_OF_CONDUCT.md")
  content = File.read(path)
  raise "Fixture setup could not find front matter in #{path}" unless content.sub!(/\A---\n.*?\n---\n/m, "---\ninvalid\n---\n")

  File.write(path, content)
end

rejection_case(cases, "invalid root index front matter", "index.md: invalid YAML front matter") do |root|
  path = File.join(root, "index.md")
  replace_once(path, "okf_version: \"0.2\"\n", "okf_version: [\n")
end

rejection_case(cases, "missing catalog ID", "every governed catalog entry requires an id") do |root|
  path = File.join(root, "catalog.yaml")
  replace_once(path, "  - id: FND-ACCESSIBILITY\n", "  - id: \n")
end

rejection_case(cases, "duplicate source-register ID", "duplicate document ID FND-ACCESSIBILITY") do |root|
  path = File.join(root, "source-register.yaml")
  replace_once(path, "  - id: FND-EVIDENCE\n", "  - id: FND-ACCESSIBILITY\n")
end

rejection_case(cases, "unknown source-register ID", "unknown document ID FND-UNKNOWN") do |root|
  path = File.join(root, "source-register.yaml")
  replace_once(path, "  - id: FND-EVIDENCE\n", "  - id: FND-UNKNOWN\n")
end

rejection_case(cases, "invalid source-register section", "source-register.yaml: documents must be a list") do |root|
  path = File.join(root, "source-register.yaml")
  File.write(path, "version: 1\ndocuments: invalid\n")
end

rejection_case(cases, "source record without document sources", "PROFILE-APPLE-INTERFACE has no front-matter sources") do |root|
  path = File.join(root, "source-register.yaml")
  replace_once(path, "  - id: FND-EVIDENCE\n", "  - id: PROFILE-APPLE-INTERFACE\n")
end

rejection_case(cases, "invalid source owner", "owner must be a non-empty string") do |root|
  path = File.join(root, "source-register.yaml")
  replace_once(path, "    owner: accessibility\n", "    owner: []\n")
end

rejection_case(cases, "invalid source review order", "next_review must be after reviewed_on") do |root|
  path = File.join(root, "source-register.yaml")
  replace_once(path, "    next_review: 2026-11-13\n", "    next_review: 2026-08-12\n")
end

rejection_case(cases, "expired source review", "source review expired on 2026-08-15") do |root|
  path = File.join(root, "source-register.yaml")
  replace_once(path, "    next_review: 2026-11-13\n", "    next_review: 2026-08-15\n")
end

rejection_case(cases, "non-independent verification", "verified.by must differ from generated.by") do |root|
  path = File.join(root, "CODE_OF_CONDUCT.md")
  content = File.read(path)
  replacement = "\\0verified: { by: codex/gpt-5, at: \"2026-08-16T23:26:21Z\" }\n"
  raise "Fixture setup could not find generated provenance in #{path}" unless content.sub!(/^generated:.*\n/, replacement)

  File.write(path, content)
end

cases.each do |name, expected, mutation|
  assert_rejected(name, expected, &mutation)
end

puts "Catalog validator negative tests valid: #{cases.length} rejection cases"
