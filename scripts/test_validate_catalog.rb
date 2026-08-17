#!/usr/bin/env ruby
# frozen_string_literal: true

# Behaviour tests for scripts/validate_catalog.rb.
#
# Each case copies the working tree into a temporary root, mutates one thing,
# and asserts the validator's exit status and message. Mutations edit YAML and
# front matter structurally wherever possible so a case stays valid when
# document content, review dates, or provenance timestamps change.

require_relative "lib/standards"
require_relative "lib/standards/test_support"

# Brings Findings, TestSupport, and the exit statuses into scope for this script.
include Standards

input_findings = Findings.new
unless InputLimits.validate(TestSupport::REPOSITORY_ROOT, input_findings)
  input_findings.report
  exit EXIT_INVALID
end

suite = TestSupport::Suite.new(
  "Catalog validator",
  validator: "validate_catalog.rb",
  root_env: "CATALOG_VALIDATION_ROOT",
  prepare: TestSupport.method(:copy_repository)
)

def catalog(root)
  File.join(root, "catalog.yaml")
end

def register(root)
  File.join(root, "source-register.yaml")
end

# A governed document that is not itself the subject of another case.
def sample_document(root)
  File.join(root, TestSupport.first_entry(root, "foundations").fetch("path"))
end

# -- accepted input ----------------------------------------------------------

suite.accepts("clean bundle", ["OKF v0.2 bundle valid", "raintree.standards catalog valid", "Governed rule structure valid"])

suite.accepts("unknown front-matter fields are preserved, not rejected") do |root|
  TestSupport.edit_front_matter(sample_document(root)) do |metadata|
    metadata["x_unregistered_field"] = "OKF requires unknown fields to survive a round trip"
  end
end

suite.accepts("a document may opt out of the current release scope") do |root|
  TestSupport.edit_front_matter(sample_document(root)) do |metadata|
    metadata["release_target"] = "v2"
  end
end

suite.rejects("oversized Markdown input", "per-file limit is #{InputLimits::MAX_FILE_BYTES} bytes") do |root|
  File.write(File.join(root, "oversized.md"), "x" * (InputLimits::MAX_FILE_BYTES + 1))
end

# -- usage -------------------------------------------------------------------

suite.rejects_usage("unknown option", "invalid option: --nonsense", ["--nonsense"])
suite.rejects_usage("misspelled release flag", "invalid option: --relase", ["--relase"])
suite.rejects_usage("unexpected positional argument", "unexpected argument", ["catalog.yaml"])

# -- catalog structure -------------------------------------------------------

suite.rejects("invalid catalog YAML", "catalog.yaml: invalid YAML") do |root|
  File.write(catalog(root), "version: [\n")
end

suite.rejects("catalog is not a mapping", "catalog.yaml: top level must be a mapping") do |root|
  File.write(catalog(root), "- one\n- two\n")
end

suite.rejects("duplicate catalog key", 'duplicate YAML mapping key "version"') do |root|
  File.write(catalog(root), "#{File.read(catalog(root))}\nversion: 1\n")
end

suite.rejects("catalog section is not a list", "catalog.yaml: patterns must be a list") do |root|
  TestSupport.edit_yaml(catalog(root)) { |document| document["patterns"] = "invalid" }
end

suite.rejects("catalog entry is not a mapping", "catalog.yaml: governance[0] must be a mapping") do |root|
  TestSupport.edit_yaml(catalog(root)) { |document| document["governance"][0] = "invalid" }
end

suite.rejects("catalog entry without a path", "requires a path") do |root|
  TestSupport.edit_yaml(catalog(root)) { |document| document["governance"][0].delete("path") }
end

suite.rejects("invalid catalog update date", "catalog.yaml: updated must be an ISO 8601 date") do |root|
  TestSupport.edit_yaml(catalog(root)) { |document| document["updated"] = "invalid" }
end

suite.rejects("catalog version drift", "catalog.yaml: version must be 1") do |root|
  TestSupport.edit_yaml(catalog(root)) { |document| document["version"] = 2 }
end

suite.rejects("catalog okf_version drift", "catalog.yaml: okf_version must be 0.2") do |root|
  TestSupport.edit_yaml(catalog(root)) { |document| document["okf_version"] = "0.3" }
end

suite.rejects("missing catalog ID", "every governed catalog entry requires an id") do |root|
  TestSupport.edit_yaml(catalog(root)) { |document| document["foundations"][0]["id"] = "" }
end

suite.rejects("catalog path that does not exist", "catalog.yaml: missing path") do |root|
  TestSupport.edit_yaml(catalog(root)) { |document| document["foundations"][0]["path"] = "foundations/absent.md" }
end

suite.rejects("duplicate catalog path", "catalog.yaml: duplicate path") do |root|
  TestSupport.edit_yaml(catalog(root)) do |document|
    document["governance"] << TestSupport.deep_copy(document["governance"][0])
  end
end

# A catalog entry must stay inside the bundle. Before this check, "../" paths
# resolved against the host filesystem and were accepted whenever they existed.
suite.rejects("catalog path escaping the bundle root", "escapes the bundle root") do |root|
  TestSupport.edit_yaml(catalog(root)) { |document| document["governance"][0]["path"] = "../outside.md" }
end

# -- front matter ------------------------------------------------------------

suite.rejects("duplicate front-matter key", 'duplicate YAML mapping key "title"') do |root|
  TestSupport.append_front_matter_line(File.join(root, "CODE_OF_CONDUCT.md"), "title: Duplicate title")
end

suite.rejects("invalid governed front matter", "invalid YAML front matter") do |root|
  TestSupport.replace_front_matter(sample_document(root), "id: [")
end

suite.rejects("non-mapping front matter", "YAML front matter must be a mapping") do |root|
  TestSupport.replace_front_matter(File.join(root, "CODE_OF_CONDUCT.md"), "invalid")
end

suite.rejects("invalid root index front matter", "index.md: invalid YAML front matter") do |root|
  TestSupport.replace_front_matter(File.join(root, "index.md"), "okf_version: [")
end

suite.rejects("root index without okf_version", "root index must declare okf_version 0.2") do |root|
  TestSupport.edit_front_matter(File.join(root, "index.md")) { |metadata| metadata.delete("okf_version") }
end

suite.rejects("governance status conflicting with status", "conflicts with governance_status") do |root|
  TestSupport.edit_front_matter(sample_document(root)) { |metadata| metadata["governance_status"] = "active" }
end

suite.rejects("unknown governance status", "invalid governance_status") do |root|
  TestSupport.edit_front_matter(sample_document(root)) { |metadata| metadata["governance_status"] = "provisional" }
end

suite.rejects("invalid last_reviewed date", "invalid last_reviewed date") do |root|
  TestSupport.edit_front_matter(sample_document(root)) { |metadata| metadata["last_reviewed"] = "not-a-date" }
end

suite.rejects("owners must not be empty", "owners must be a non-empty list") do |root|
  TestSupport.edit_front_matter(sample_document(root)) { |metadata| metadata["owners"] = [] }
end

suite.rejects("tags must be unique", "tags must be a unique list") do |root|
  TestSupport.edit_front_matter(sample_document(root)) do |metadata|
    metadata["tags"] = Array(metadata["tags"]).first(1) * 2
  end
end

suite.rejects("non-independent verification", "verified.by must differ from generated.by") do |root|
  path = File.join(root, "CODE_OF_CONDUCT.md")
  TestSupport.edit_front_matter(path) do |metadata|
    metadata["verified"] = { "by" => metadata.dig("generated", "by"), "at" => "2026-01-01T00:00:00Z" }
  end
end

suite.rejects("verification by an actor outside the OKF convention", "verified.by does not follow the OKF actor convention") do |root|
  TestSupport.edit_front_matter(File.join(root, "CODE_OF_CONDUCT.md")) do |metadata|
    metadata["verified"] = { "by" => "somebody", "at" => "2026-01-01T00:00:00Z" }
  end
end

suite.rejects("verification without a timestamp", "verified.at must be an ISO 8601 datetime") do |root|
  TestSupport.edit_front_matter(File.join(root, "CODE_OF_CONDUCT.md")) do |metadata|
    metadata["verified"] = { "by" => "human:reviewer", "at" => "sometime" }
  end
end

# -- schema conformance ------------------------------------------------------

# schema/standard.schema.json is applied to governed front matter, so a value
# only the schema constrains must still be rejected.
suite.rejects("front matter violating the schema ID pattern", "does not match") do |root|
  entry = TestSupport.first_entry(root, "foundations")
  TestSupport.edit_yaml(catalog(root)) do |document|
    document["foundations"].find { |row| row["path"] == entry["path"] }["id"] = "fnd_lowercase"
  end
  TestSupport.edit_front_matter(File.join(root, entry.fetch("path"))) do |metadata|
    metadata["id"] = "fnd_lowercase"
  end
end

suite.rejects("generated provenance with an unknown subfield", "unknown property") do |root|
  TestSupport.edit_front_matter(sample_document(root)) do |metadata|
    metadata["generated"] = metadata["generated"].merge("note" => "additionalProperties is false here")
  end
end

suite.rejects("owner entry that is not a string", "expected string") do |root|
  TestSupport.edit_front_matter(sample_document(root)) { |metadata| metadata["owners"] = [42] }
end

# -- source register ---------------------------------------------------------

suite.rejects("duplicate source-register ID", "duplicate document ID") do |root|
  TestSupport.edit_yaml(register(root)) do |document|
    document["documents"] << TestSupport.deep_copy(document["documents"][0])
  end
end

suite.rejects("unknown source-register ID", "unknown document ID FND-UNKNOWN") do |root|
  TestSupport.edit_yaml(register(root)) { |document| document["documents"][0]["id"] = "FND-UNKNOWN" }
end

suite.rejects("source-register documents is not a list", "source-register.yaml: documents must be a list") do |root|
  TestSupport.edit_yaml(register(root)) { |document| document["documents"] = "invalid" }
end

suite.rejects("source-register record is not a mapping", "source-register.yaml: documents[0] must be a mapping") do |root|
  TestSupport.edit_yaml(register(root)) { |document| document["documents"][0] = "invalid" }
end

suite.rejects("source record without document sources", "has no front-matter sources") do |root|
  # Any governed document that carries no front-matter sources will do.
  catalog_document = YAML.safe_load(File.read(catalog(root)), permitted_classes: [Date], aliases: false)
  unsourced = catalog_document.fetch("profiles").find do |entry|
    metadata = YAML.safe_load(
      File.read(File.join(root, entry.fetch("path")))[Standards::Document::FRONT_MATTER, 1],
      permitted_classes: [Date, Time], aliases: false
    )
    !metadata.key?("sources")
  end
  raise TestSupport::FixtureError, "every profile declares sources" if unsourced.nil?

  TestSupport.edit_yaml(register(root)) { |document| document["documents"][0]["id"] = unsourced.fetch("id") }
end

suite.rejects("invalid source owner", "owner must be a non-empty string") do |root|
  TestSupport.edit_yaml(register(root)) { |document| document["documents"][0]["owner"] = [] }
end

suite.rejects("invalid source review order", "next_review must be after reviewed_on") do |root|
  TestSupport.edit_yaml(register(root)) do |document|
    record = document["documents"][0]
    record["next_review"] = record["reviewed_on"] - 1
  end
end

# Dated relative to today rather than to a literal in the register, so the case
# keeps testing expiry after the register is next reviewed.
expired_on = Date.today - 1
suite.rejects("expired source review", "source review expired on #{expired_on}") do |root|
  TestSupport.edit_yaml(register(root)) do |document|
    record = document["documents"][0]
    record["reviewed_on"] = expired_on - 30
    record["next_review"] = expired_on
  end
end

suite.rejects("invalid volatility", "invalid volatility") do |root|
  TestSupport.edit_yaml(register(root)) { |document| document["documents"][0]["volatility"] = "extreme" }
end

# -- bundle structure --------------------------------------------------------

suite.rejects("broken Markdown link", "Broken Markdown link") do |root|
  File.write(File.join(root, "coverage.md"), "#{File.read(File.join(root, 'coverage.md'))}\n[gone](./absent-target.md)\n")
end

# A link resolving outside the bundle used to be accepted whenever the target
# happened to exist on the host filesystem.
suite.rejects("Markdown link escaping the bundle", "escapes the bundle") do |root|
  File.write(File.join(root, "coverage.md"), "#{File.read(File.join(root, 'coverage.md'))}\n[out](../escape.md)\n")
end

suite.rejects("stale directory index", "missing entries for") do |root|
  File.write(File.join(root, "profiles", "unlisted-profile.md"), <<~MARKDOWN)
    ---
    type: Profile
    description: A profile that the directory index does not list.
    generated: { by: process:test, at: "2026-01-01T00:00:00Z" }
    ---

    # Unlisted profile
  MARKDOWN
end

suite.rejects("nested reserved file carrying front matter", "reserved nested files must not contain front matter") do |root|
  File.write(File.join(root, "profiles", "log.md"), "---\ntype: Log\n---\n\n# Log\n")
end

suite.rejects("Markdown file without front matter", "missing OKF YAML front matter") do |root|
  File.write(File.join(root, "orphan.md"), "# No front matter here\n")
end

# -- release gate ------------------------------------------------------------

# The library is pre-v1 and deliberately holds drafts, so --release is expected
# to report blockers. These cases assert the gate reports them rather than that
# the repository is release-ready.
suite.rejects("release gate reports draft documents", "remains draft", argv: ["--release"])

suite.rejects(
  "release gate reports unverified stable documents",
  "stable release document requires independent verified provenance",
  argv: ["--release"]
)

suite.rejects(
  "release gate reports the work-in-progress warning",
  "remove the work-in-progress warning before release",
  argv: ["--release"]
)

# The same unverified stable documents must not fail an ordinary run: the
# schema's release rule lives in $defs/releaseGate and applies only here.
suite.accepts_without("ordinary run ignores the release gate", "stable release document requires")

exit(suite.run ? Standards::EXIT_SUCCESS : Standards::EXIT_INVALID)
