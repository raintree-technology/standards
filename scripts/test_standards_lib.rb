#!/usr/bin/env ruby
# frozen_string_literal: true

# Unit tests for the shared validator library.
#
# The suites in test_validate_catalog.rb and test_validate_integrations.rb drive
# the validators end to end through a subprocess, which is the right level for
# rules but a poor one for the edge cases in path handling and schema
# evaluation. These exercise those units directly.

require "date"
require "fileutils"
require "stringio"
require "tmpdir"

require_relative "lib/standards"
require_relative "lib/standards/catalog_validator"
require_relative "lib/standards/test_support"

failures = []
checks = 0
REPOSITORY_ROOT = File.expand_path("..", __dir__)

input_findings = Standards::Findings.new
unless Standards::InputLimits.validate(REPOSITORY_ROOT, input_findings)
  input_findings.report
  exit Standards::EXIT_INVALID
end

def expect(failures, description, actual, expected)
  return if actual == expected

  failures << "#{description}: expected #{expected.inspect}, got #{actual.inspect}"
end

# -- Findings ----------------------------------------------------------------

checks += 1
findings = Standards::Findings.new
findings.add("one").add("one").add("two")
expect(failures, "Findings de-duplicates repeated messages", findings.to_a, %w[one two])

checks += 1
findings = Standards::Findings.new
findings.add_unless(true, "not recorded").add_unless(false, "recorded")
expect(failures, "Findings#add_unless records only on a falsy condition", findings.to_a, ["recorded"])

checks += 1
buffer = StringIO.new
Standards::Findings.new.report(buffer)
expect(failures, "an empty Findings writes nothing, not a blank line", buffer.string, "")

# -- Paths -------------------------------------------------------------------

Dir.mktmpdir("standards-paths-") do |root|
  FileUtils.mkdir_p(File.join(root, "nested"))
  File.write(File.join(root, "nested", "file.md"), "x")

  checks += 1
  expect(failures, "a path inside the root resolves", !Standards::Paths.resolve(root, "nested/file.md").nil?, true)

  checks += 1
  expect(failures, "a parent traversal resolves to nil", Standards::Paths.resolve(root, "../outside.md"), nil)

  checks += 1
  expect(failures, "a deep traversal resolves to nil", Standards::Paths.resolve(root, "nested/../../outside.md"), nil)

  checks += 1
  expect(failures, "an absolute path outside the root is not contained",
         Standards::Paths.contained?(root, "/etc/hosts"), false)

  checks += 1
  expect(failures, "the root itself is contained", Standards::Paths.contained?(root, root), true)

  # A sibling directory whose name merely starts with the root's name must not
  # count as contained: a prefix test without a separator would accept it.
  checks += 1
  expect(failures, "a sibling sharing the root's name prefix is not contained",
         Standards::Paths.contained?(root, "#{root}-other/file.md"), false)

  checks += 1
  expect(failures, "glob results are relative and sorted",
         Standards::Paths.glob(root, "**/*.md"), ["nested/file.md"])
end

# Containment resolves symlinks on both sides. Resolving only the candidate
# would reject every path on macOS, where /tmp is itself a link to /private/tmp.
Dir.mktmpdir("standards-symlink-") do |parent|
  root = File.join(parent, "bundle")
  outside = File.join(parent, "outside")
  FileUtils.mkdir_p(root)
  FileUtils.mkdir_p(outside)
  File.write(File.join(outside, "secret.md"), "x")
  File.write(File.join(root, "real.md"), "x")
  File.symlink(File.join(outside, "secret.md"), File.join(root, "leak.md"))
  File.symlink(File.join(root, "real.md"), File.join(root, "alias.md"))

  checks += 1
  expect(failures, "a symlink inside the bundle pointing outside is rejected",
         Standards::Paths.resolve(root, "leak.md"), nil)

  checks += 1
  expect(failures, "a symlink inside the bundle pointing inside is accepted",
         !Standards::Paths.resolve(root, "alias.md").nil?, true)

  checks += 1
  expect(failures, "a plain file inside the bundle is accepted",
         !Standards::Paths.resolve(root, "real.md").nil?, true)

  # The common macOS case: the bundle is reached through a symlinked parent.
  linked_root = File.join(parent, "linked-bundle")
  File.symlink(root, linked_root)
  checks += 1
  expect(failures, "a bundle reached through a symlinked root still resolves",
         !Standards::Paths.resolve(linked_root, "real.md").nil?, true)

  # Callers ask about files that do not exist yet, and those must not blow up.
  checks += 1
  expect(failures, "a missing file inside the bundle still resolves",
         !Standards::Paths.resolve(root, "absent/deeper.md").nil?, true)

  checks += 1
  expect(failures, "a missing file outside the bundle resolves to nil",
         Standards::Paths.resolve(root, "../absent.md"), nil)
end

# Every temporary root the harness creates must be removed, including when a
# fixture raises partway through.
checks += 1
leaked = nil
begin
  Dir.mktmpdir("standards-cleanup-") do |root|
    leaked = root
    File.write(File.join(root, "file.md"), "x")
    raise "fixture failure"
  end
rescue RuntimeError
  # expected
end
expect(failures, "a temporary root is removed even when a fixture raises", File.exist?(leaked), false)

# A checkout under a directory containing glob metacharacters used to match no
# files at all, so the bundle validated as empty and still exited 0.
Dir.mktmpdir("standards-glob-") do |parent|
  root = File.join(parent, "repo [v2] {a}")
  FileUtils.mkdir_p(root)
  File.write(File.join(root, "index.md"), "x")
  File.write(File.join(root, "other.md"), "x")

  checks += 1
  expect(failures, "globs work under a root containing glob metacharacters",
         Standards::Paths.glob(root, "*.md"), ["index.md", "other.md"])
end

# -- InputLimits -------------------------------------------------------------

Dir.mktmpdir("standards-input-limits-") do |root|
  File.write(File.join(root, "one.md"), "1234")
  File.write(File.join(root, "two.yaml"), "a: 1\n")

  checks += 1
  findings = Standards::Findings.new
  accepted = Standards::InputLimits.validate(root, findings, max_files: 2, max_file_bytes: 8, max_total_bytes: 16)
  expect(failures, "bounded validator input is accepted", [accepted, findings.to_a], [true, []])

  checks += 1
  findings = Standards::Findings.new
  Standards::InputLimits.validate(root, findings, max_files: 2, max_file_bytes: 3, max_total_bytes: 16)
  expect(failures, "an oversized file is reported", findings.to_a.any? { |message| message.include?("per-file limit") }, true)

  checks += 1
  findings = Standards::Findings.new
  Standards::InputLimits.validate(root, findings, max_files: 1, max_file_bytes: 8, max_total_bytes: 16)
  expect(failures, "too many files are reported", findings.to_a.any? { |message| message.include?("files; limit") }, true)

  checks += 1
  findings = Standards::Findings.new
  Standards::InputLimits.validate(root, findings, max_files: 2, max_file_bytes: 8, max_total_bytes: 5)
  expect(failures, "excess total input is reported", findings.to_a.any? { |message| message.include?("total limit") }, true)
end

Dir.mktmpdir("standards-input-symlink-") do |parent|
  root = File.join(parent, "bundle")
  FileUtils.mkdir_p(root)
  outside = File.join(parent, "outside.md")
  File.write(outside, "secret")
  File.symlink(outside, File.join(root, "leak.md"))

  checks += 1
  findings = Standards::Findings.new
  Standards::InputLimits.validate(root, findings)
  expect(failures, "an outward input symlink is rejected",
         findings.to_a, ["leak.md: input path escapes the bundle root"])
end

# -- YamlSource --------------------------------------------------------------

checks += 1
findings = Standards::Findings.new
expect(failures, "a top-level sequence yields an empty mapping",
       Standards::YamlSource.load_mapping("- a\n- b\n", "x.yaml", findings), {})
expect(failures, "a top-level sequence is reported", findings.to_a, ["x.yaml: top level must be a mapping"])

checks += 1
findings = Standards::Findings.new
Standards::YamlSource.load_mapping("", "x.yaml", findings)
expect(failures, "an empty document is reported", findings.to_a, ["x.yaml: top level must be a mapping"])

checks += 1
findings = Standards::Findings.new
Standards::YamlSource.load_mapping("a: [\n", "x.yaml", findings)
expect(failures, "invalid YAML is reported on one line", findings.length, 1)
expect(failures, "invalid YAML is reported as such", findings.to_a.first.start_with?("x.yaml: invalid YAML ("), true)

# Aliases are disabled, so a YAML bomb is refused rather than expanded.
checks += 1
findings = Standards::Findings.new
Standards::YamlSource.load_mapping("a: &x [1]\nb: *x\n", "x.yaml", findings)
expect(failures, "YAML aliases are refused", findings.to_a.first.include?("invalid YAML"), true)

checks += 1
findings = Standards::Findings.new
Standards::YamlSource.load_mapping("a: 1\na: 2\n", "x.yaml", findings)
expect(failures, "duplicate keys are reported", findings.to_a, ['x.yaml: duplicate YAML mapping key "a"'])

checks += 1
findings = Standards::Findings.new
tree = Psych.parse_stream("a:\n  b:\n    c: 1\n")
accepted = Standards::YamlSource.duplicate_keys(tree, "x.yaml", findings, max_depth: 1)
expect(failures, "deep YAML is rejected before safe loading", accepted, false)
expect(failures, "deep YAML reports its limit", findings.to_a, ["x.yaml: YAML structure exceeds the maximum depth of 1"])

checks += 1
findings = Standards::Findings.new
tree = Psych.parse_stream("a: 1\nb: 2\n")
accepted = Standards::YamlSource.duplicate_keys(tree, "x.yaml", findings, max_nodes: 3)
expect(failures, "large YAML trees are rejected before safe loading", accepted, false)
expect(failures, "large YAML trees report their limit", findings.to_a, ["x.yaml: YAML structure exceeds the 3-node limit"])

checks += 1
findings = Standards::Findings.new
rows = Standards::YamlSource.mapping_rows([{ "id" => 1 }, "scalar", 42], "x.yaml: rows", findings)
expect(failures, "non-mapping rows are dropped", rows, [{ "id" => 1 }])
expect(failures, "non-mapping rows are reported",
       findings.to_a, ["x.yaml: rows[1] must be a mapping", "x.yaml: rows[2] must be a mapping"])

# -- Document ----------------------------------------------------------------

checks += 1
findings = Standards::Findings.new
document = Standards::Document.new("d.md", "---\ntype: Standard\n---\n\n## Sources\n\n[a](https://a.test)\n\n## After\n\n[b](https://b.test)\n", findings)
expect(failures, "a section stops at the next heading",
       document.section("Sources").to_s.scan(%r{\]\((https?://[^)]+)\)}).flatten, ["https://a.test"])

checks += 1
findings = Standards::Findings.new
document = Standards::Document.new("d.md", "# No front matter\n", findings)
expect(failures, "absent front matter is distinguishable from unparseable", document.front_matter?, false)
expect(failures, "absent front matter is not itself a finding", findings.to_a, [])

# -- JsonSchema --------------------------------------------------------------

def schema_errors(instance, schema)
  Standards::JsonSchema.validate(instance, schema)
end

checks += 1
expect(failures, "a conforming object passes",
       schema_errors({ "a" => "x" }, { "type" => "object", "required" => ["a"] }), [])

checks += 1
expect(failures, "a missing required property is reported",
       schema_errors({}, { "required" => ["a"] }).length, 1)

checks += 1
expect(failures, "additionalProperties false rejects extras",
       schema_errors({ "a" => 1, "b" => 2 }, { "properties" => { "a" => {} }, "additionalProperties" => false }).length, 1)

checks += 1
expect(failures, "enum membership is enforced",
       schema_errors("z", { "enum" => %w[x y] }).length, 1)

checks += 1
expect(failures, "patterns are enforced",
       schema_errors("abc", { "type" => "string", "pattern" => "^[0-9]+$" }).length, 1)

checks += 1
expect(failures, "uniqueItems is enforced",
       schema_errors([1, 1], { "type" => "array", "uniqueItems" => true }).length, 1)

checks += 1
expect(failures, "minItems is enforced",
       schema_errors([], { "type" => "array", "minItems" => 1 }).length, 1)

checks += 1
expect(failures, "integer and number are distinguished",
       schema_errors(1.5, { "type" => "integer" }).length, 1)

checks += 1
expect(failures, "booleans are not numbers", schema_errors(true, { "type" => "number" }).length, 1)

checks += 1
expect(failures, "local $ref resolves",
       schema_errors({ "a" => "x" },
                     { "properties" => { "a" => { "$ref" => "#/$defs/s" } },
                       "$defs" => { "s" => { "type" => "integer" } } }).length, 1)

checks += 1
expect(failures, "if/then applies only when if matches",
       schema_errors({ "status" => "draft" },
                     { "if" => { "properties" => { "status" => { "const" => "stable" } }, "required" => ["status"] },
                       "then" => { "required" => ["verified"] } }), [])

checks += 1
expect(failures, "if/then applies when if matches",
       schema_errors({ "status" => "stable" },
                     { "if" => { "properties" => { "status" => { "const" => "stable" } }, "required" => ["status"] },
                       "then" => { "required" => ["verified"] } }).length, 1)

checks += 1
expect(failures, "oneOf requires exactly one match",
       schema_errors(1, { "oneOf" => [{ "type" => "integer" }, { "type" => "number" }] }).length, 1)

# YAML gives Date and Time objects where the schemas describe ISO strings.
checks += 1
expect(failures, "a YAML Date satisfies format: date",
       schema_errors(Date.new(2026, 8, 16), { "type" => "string", "format" => "date" }), [])

checks += 1
expect(failures, "a YAML Time satisfies format: date-time",
       schema_errors(Time.utc(2026, 8, 16, 1, 2, 3), { "type" => "string", "format" => "date-time" }), [])

checks += 1
expect(failures, "a malformed date is reported",
       schema_errors("2026-13-99", { "type" => "string", "format" => "date" }).length, 1)

# An unimplemented keyword must fail loudly rather than being ignored, which is
# what stops a schema from gaining a constraint that quietly does nothing.
checks += 1
raised = begin
  schema_errors({}, { "dependentRequired" => { "a" => ["b"] } })
  false
rescue Standards::JsonSchema::UnsupportedKeyword
  true
end
expect(failures, "an unsupported keyword raises rather than being ignored", raised, true)

checks += 1
raised = begin
  schema_errors({}, { "$ref" => "https://example.test/schema.json" })
  false
rescue Standards::JsonSchema::UnsupportedKeyword
  true
end
expect(failures, "a remote $ref raises rather than being skipped", raised, true)

# -- CatalogValidator on a synthetic root ------------------------------------

# An empty root must not report success. Before the glob fix, a root the globs
# could not read produced "0 Markdown files" and exit 0.
Dir.mktmpdir("standards-empty-") do |root|
  checks += 1
  validator = Standards::CatalogValidator.new(root).run
  expect(failures, "an empty root is invalid", validator.valid?, false)
  expect(failures, "an empty root reports the missing catalog",
         validator.findings.to_a.include?("Missing catalog.yaml"), true)
end

# The release gate must depend on the injected date, not on the wall clock, so
# the expiry rule stays testable.
Dir.mktmpdir("standards-today-") do |root|
  Standards::TestSupport.copy_repository(root)
  Standards::TestSupport.edit_yaml(File.join(root, "source-register.yaml")) do |document|
    document["documents"][0]["reviewed_on"] = Date.new(2026, 1, 1)
    document["documents"][0]["next_review"] = Date.new(2026, 6, 1)
  end

  checks += 1
  before = Standards::CatalogValidator.new(root, today: Date.new(2026, 5, 1)).run
  expired_before = before.findings.to_a.grep(/source review expired/)
  expect(failures, "a review in the future is not expired", expired_before, [])

  checks += 1
  after = Standards::CatalogValidator.new(root, today: Date.new(2026, 7, 1)).run
  expired_after = after.findings.to_a.grep(/source review expired/)
  expect(failures, "a review in the past is expired", expired_after.length, 1)
end

# -- pinned Ruby version -----------------------------------------------------

# Two files name the interpreter: .ruby-version for rbenv, chruby, and anything
# else following the Ruby convention, and .tool-versions for mise, which is what
# CI installs from. They must not drift apart, and both must satisfy the floor
# the library enforces at startup.
ruby_version = File.read(File.join(REPOSITORY_ROOT, ".ruby-version")).strip
tool_versions = File.read(File.join(REPOSITORY_ROOT, ".tool-versions"))
                    .lines
                    .filter_map { |line| line.split[1] if line.split.first == "ruby" }

checks += 1
expect(failures, ".tool-versions pins exactly one Ruby", tool_versions.length, 1)

checks += 1
expect(failures, ".ruby-version and .tool-versions agree", tool_versions.first, ruby_version)

checks += 1
expect(failures, "the pinned Ruby satisfies the enforced minimum",
       Gem::Version.new(ruby_version) >= Gem::Version.new(Standards::MINIMUM_RUBY), true)

if failures.empty?
  puts "Validator library tests valid: #{checks} cases"
  exit Standards::EXIT_SUCCESS
end

failures.each { |message| warn message }
warn "Validator library: #{failures.length} of #{checks} cases failed"
exit Standards::EXIT_INVALID
