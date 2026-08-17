#!/usr/bin/env ruby
# frozen_string_literal: true

# Behaviour tests for scripts/validate_integrations.rb.
#
# Cases address rows by role -- "the first mutating capability", "a capability
# that observes" -- rather than by hardcoded ID or by substituting sentences
# from capability prose, so they survive edits to the bundle's content.

require "date"

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
  "Integration validator",
  validator: "validate_integrations.rb",
  root_env: "INTEGRATION_VALIDATION_ROOT",
  prepare: TestSupport.method(:copy_integration_bundle)
)

BUNDLE = File.join("integrations", "google-search-console")

def bundle_file(root, name)
  File.join(root, BUNDLE, name)
end

def capabilities(root)
  bundle_file(root, "capabilities.yaml")
end

def sources(root)
  bundle_file(root, "sources.yaml")
end

def workflows(root)
  bundle_file(root, "workflows.yaml")
end

def evaluations(root)
  bundle_file(root, "evaluations.yaml")
end

def semantics(root)
  bundle_file(root, "data-semantics.yaml")
end

def provider_file(root, provider, name)
  File.join(root, "integrations", provider, name)
end

# Finds a capability by the role it plays, not by its identifier.
def capability_where(root, &predicate)
  TestSupport.find_row(capabilities(root), "capabilities", &predicate)
end

def mutating_capability(root)
  capability_where(root) { |row| %w[mutate_reversible mutate_high_impact].include?(row["effect"]) }
end

def observing_capability(root)
  capability_where(root) { |row| row["effect"] == "observe" }
end

# -- accepted input ----------------------------------------------------------

suite.accepts("clean bundle", "Integration bundle valid")

suite.rejects("oversized YAML input", "per-file limit is #{InputLimits::MAX_FILE_BYTES} bytes") do |root|
  File.write(capabilities(root), "x" * (InputLimits::MAX_FILE_BYTES + 1))
end

# -- usage -------------------------------------------------------------------

suite.rejects_usage("unknown option", "invalid option: --bogus", ["--bogus"])
suite.rejects_usage("unexpected positional argument", "unexpected argument", ["capabilities.yaml"])

# -- malformed input ---------------------------------------------------------

# These three previously aborted with TypeError or NoMethodError backtraces
# instead of reporting a validation failure.

suite.rejects("top-level sequence instead of a mapping", "top level must be a mapping") do |root|
  File.write(workflows(root), "- one\n- two\n")
end

suite.rejects("empty document", "top level must be a mapping") do |root|
  File.write(evaluations(root), "")
end

suite.rejects("list entry that is not a mapping", "capabilities.yaml: capabilities[0] must be a mapping") do |root|
  TestSupport.edit_yaml(capabilities(root)) { |document| document["capabilities"][0] = 42 }
end

suite.rejects("invalid YAML", "invalid YAML") do |root|
  File.write(semantics(root), "concepts: [\n")
end

suite.rejects("missing artifact", "Missing integration artifact") do |root|
  FileUtils.rm(workflows(root))
end

suite.rejects("missing schema", "Missing integration schema") do |root|
  FileUtils.rm(File.join(root, "schema", "integration-capability.schema.json"))
end

suite.rejects("manifest integration differs from directory", "integration must match directory stripe") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "manifest.yaml")) { |document| document["integration"] = "payments" }
end

suite.rejects("skill route claims authority", "skills are review aids, not authority") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "manifest.yaml")) do |document|
    document["skill_routes"][0]["authority"] = "policy"
  end
end

suite.rejects("skill route name is duplicated", "duplicate skill route stripe:stripe-best-practices") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "manifest.yaml")) do |document|
    document["skill_routes"] << {
      "name" => "stripe:stripe-best-practices", "availability" => "not_available", "authority" => "review_aid"
    }
  end
end

suite.rejects("provider source leaves official domain", "URL must use an official HTTPS domain") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "sources.yaml")) do |document|
    document["sources"][0]["url"] = "https://example.com/payments"
  end
end

suite.rejects("engineering article is sole authority for a mapped surface", "requires provider documentation; engineering sources are informative") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "sources.yaml")) do |document|
    source = document["sources"].find { |row| row["id"] == "STRIPE-SRC-PAYMENTS" }
    source["authority"] = "provider_engineering"
    document["coverage"].find { |row| row["surface"] == "checkout-and-payment-creation" }["sources"] = ["STRIPE-SRC-PAYMENTS"]
  end
end

suite.rejects("engineering article is sole authority for a capability", "requires provider documentation; engineering sources are informative") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "sources.yaml")) do |document|
    document["sources"] << {
      "id" => "STRIPE-SRC-ENG-ONLY", "title" => "Engineering article", "url" => "https://stripe.com/blog/idempotency",
      "topic" => "design rationale", "authority" => "provider_engineering", "volatility" => "low"
    }
    document["coverage"][0]["sources"] << "STRIPE-SRC-ENG-ONLY"
  end
  TestSupport.edit_yaml(provider_file(root, "stripe", "capabilities.yaml")) do |document|
    document["capabilities"][0]["sources"] = ["STRIPE-SRC-ENG-ONLY"]
  end
end

suite.rejects("provider source uses an unknown source role", "invalid authority vendor_marketing") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "sources.yaml")) do |document|
    document["sources"][0]["authority"] = "vendor_marketing"
  end
end

suite.rejects("independent engineering source leaves its allowlist", "URL must use an allowlisted informative HTTPS domain") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "sources.yaml")) do |document|
    source = document["sources"].find { |row| row["authority"] == "independent_engineering" }
    source["url"] = "https://example.com/idempotency"
  end
end

suite.rejects("provider capability uses an undeclared interface", "invalid interface unknown_surface") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "capabilities.yaml")) do |document|
    document["capabilities"][0]["interface"] = "unknown_surface"
  end
end

suite.rejects("capability manifest omits its vocabulary", "capability bundles require vocabulary") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "manifest.yaml")) { |document| document.delete("vocabulary") }
end

suite.rejects("provider ID crosses artifact namespaces", "Duplicate integration ID STRIPE-CAP-CHECKOUT") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "evaluations.yaml")) do |document|
    document["evaluations"][0]["id"] = "STRIPE-CAP-CHECKOUT"
  end
end

suite.rejects("provider coverage omits source evidence", "coverage checkout-and-payment-creation: sources must be non-empty") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "sources.yaml")) do |document|
    document["coverage"][0]["sources"] = []
  end
end

suite.rejects("provider capability is absent from zero-gap ledger", "zero-gap ledger does not classify capability STRIPE-CAP-REFUND") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "sources.yaml")) do |document|
    document["coverage"].each { |row| row["capabilities"] = Array(row["capabilities"]) - ["STRIPE-CAP-REFUND"] }
  end
end

suite.rejects("provider capability references an unknown semantic", "unknown semantic STRIPE-SEM-UNKNOWN") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "capabilities.yaml")) do |document|
    document["capabilities"][0]["data_semantics"] = ["STRIPE-SEM-UNKNOWN"]
  end
end

suite.rejects("provider mutation is not routed", "mutation STRIPE-CAP-REFUND is not routed") do |root|
  %w[workflows.yaml evaluations.yaml].each do |name|
    field = name == "workflows.yaml" ? "workflows" : "evaluations"
    TestSupport.edit_yaml(provider_file(root, "stripe", name)) do |document|
      document[field].each { |row| row["capabilities"] = Array(row["capabilities"]) - ["STRIPE-CAP-REFUND"] }
    end
  end
end

suite.rejects("provider capability lacks an evaluation route", "capability STRIPE-CAP-API-UPGRADE is not routed through an evaluation") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "evaluations.yaml")) do |document|
    document["evaluations"].each { |row| row["capabilities"] = Array(row["capabilities"]) - ["STRIPE-CAP-API-UPGRADE"] }
  end
end

suite.rejects("provider official source is declared but unused", "source STRIPE-SRC-UNUSED is not used") do |root|
  TestSupport.edit_yaml(provider_file(root, "stripe", "sources.yaml")) do |document|
    document["sources"] << {
      "id" => "STRIPE-SRC-UNUSED", "title" => "Unused", "url" => "https://docs.stripe.com/",
      "topic" => "unused test source", "authority" => "provider_documentation", "volatility" => "low"
    }
  end
end

# -- identity and references -------------------------------------------------

suite.rejects("duplicate capability ID", "Duplicate capability id") do |root|
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"][1]["id"] = document["capabilities"][0]["id"]
  end
end

suite.rejects("duplicate YAML key", "duplicate YAML mapping key") do |root|
  content = File.read(capabilities(root))
  File.write(capabilities(root), "#{content}\nversion: 1\n")
end

suite.rejects("unknown source reference", "unknown source GSC-SRC-UNKNOWN") do |root|
  target = mutating_capability(root).fetch("id")
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"].find { |row| row["id"] == target }["sources"] = ["GSC-SRC-UNKNOWN"]
  end
end

suite.rejects("missing capability sources", "sources must be a non-empty unique string list") do |root|
  target = mutating_capability(root).fetch("id")
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"].find { |row| row["id"] == target }["sources"] = []
  end
end

suite.rejects("unknown workflow capability", "unknown capability GSC-CAP-UNKNOWN") do |root|
  TestSupport.edit_yaml(workflows(root)) do |document|
    document["workflows"][0]["capabilities"] = ["GSC-CAP-UNKNOWN"]
  end
end

suite.rejects("unknown evaluation capability", "unknown capability GSC-CAP-UNKNOWN") do |root|
  TestSupport.edit_yaml(evaluations(root)) do |document|
    document["evaluations"][0]["capabilities"] = ["GSC-CAP-UNKNOWN"]
  end
end

suite.rejects("evaluation referencing an unknown workflow", "unknown workflow") do |root|
  TestSupport.edit_yaml(evaluations(root)) { |document| document["evaluations"][0]["workflow"] = "GSC-WF-UNKNOWN" }
end

# -- access and effect rules -------------------------------------------------

suite.rejects("invalid source authority", "invalid authority secondary_summary") do |root|
  TestSupport.edit_yaml(sources(root)) { |document| document["sources"][0]["authority"] = "secondary_summary" }
end

suite.rejects("non-Google source URL", "URL must use official Google HTTPS documentation") do |root|
  TestSupport.edit_yaml(sources(root)) { |document| document["sources"][0]["url"] = "https://example.com/guide" }
end

suite.rejects("invalid OAuth scope", "invalid OAuth scopes https://www.googleapis.com/auth/unknown") do |root|
  target = observing_capability(root).fetch("id")
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"].find { |row| row["id"] == target }["access"]["oauth_scopes"] =
      ["https://www.googleapis.com/auth/unknown"]
  end
end

suite.rejects("invalid property role", "invalid property roles") do |root|
  target = observing_capability(root).fetch("id")
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"].find { |row| row["id"] == target }["access"]["property_roles"] = ["superuser"]
  end
end

suite.rejects("unapproved mutation", "mutation cannot use approval none") do |root|
  target = mutating_capability(root).fetch("id")
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"].find { |row| row["id"] == target }["approval"] = "none"
  end
end

suite.rejects("mutation without rollback", "mutation requires rollback or irreversibility text") do |root|
  target = mutating_capability(root).fetch("id")
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"].find { |row| row["id"] == target }["rollback"] = "Not applicable"
  end
end

suite.rejects("observe effect requiring approval", "observe and diagnose effects require approval none") do |root|
  target = observing_capability(root).fetch("id")
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"].find { |row| row["id"] == target }["approval"] = "bounded"
  end
end

suite.rejects("high-impact mutation with bounded approval", "high-impact mutation requires exact or human_only approval") do |root|
  target = capability_where(root) { |row| row["effect"] == "mutate_high_impact" }&.fetch("id")
  raise TestSupport::FixtureError, "the bundle declares no high-impact mutation" if target.nil?

  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"].find { |row| row["id"] == target }["approval"] = "bounded"
  end
end

suite.rejects("unrouted mutation", "is not routed through a workflow or evaluation") do |root|
  target = mutating_capability(root).fetch("id")
  [workflows(root), evaluations(root)].each do |path|
    key = File.basename(path, ".yaml")
    TestSupport.edit_yaml(path) do |document|
      Array(document[key]).each do |row|
        row["capabilities"] = Array(row["capabilities"]) - [target]
      end
    end
  end
end

# -- limits and completeness -------------------------------------------------

suite.rejects("incomplete limit dimensions", "limits must declare exactly") do |root|
  target = observing_capability(root).fetch("id")
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"].find { |row| row["id"] == target }["limits"].delete("quotas")
  end
end

suite.rejects("empty limit dimension", "must be a non-empty unique string list") do |root|
  target = observing_capability(root).fetch("id")
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"].find { |row| row["id"] == target }["limits"]["quotas"] = []
  end
end

suite.rejects("unknown capability field", "unknown fields") do |root|
  target = observing_capability(root).fetch("id")
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"].find { |row| row["id"] == target }["unexpected"] = "value"
  end
end

suite.rejects("unknown top-level field", "unknown top-level fields") do |root|
  TestSupport.edit_yaml(workflows(root)) { |document| document["unexpected"] = true }
end

suite.rejects("capability missing from the zero-gap ledger", "zero-gap ledger does not classify capability") do |root|
  target = observing_capability(root).fetch("id")
  TestSupport.edit_yaml(sources(root)) do |document|
    Array(document["coverage"]).each do |row|
      row["capabilities"] = Array(row["capabilities"]) - [target]
    end
  end
end

# -- schema conformance ------------------------------------------------------

# schema/integration-capability.schema.json is applied to capabilities.yaml, so
# a constraint only the schema expresses must still be rejected. The handwritten
# validator has never checked the capability ID pattern.
suite.rejects("capability ID violating the schema pattern", "does not match") do |root|
  TestSupport.edit_yaml(capabilities(root)) do |document|
    document["capabilities"][0]["id"] = "gsc_cap_lowercase"
  end
end

# -- freshness ---------------------------------------------------------------

expired_on = Date.today - 1
suite.rejects("expired source review", "official-source review expired on #{expired_on}") do |root|
  TestSupport.edit_yaml(sources(root)) do |document|
    document["reviewed_on"] = expired_on - 30
    document["freshness"]["next_review"] = expired_on
    document["freshness"]["cadence_days"] = 90
  end
end

suite.rejects("review order inverted", "next_review must be after reviewed_on") do |root|
  TestSupport.edit_yaml(sources(root)) do |document|
    document["freshness"]["next_review"] = document["reviewed_on"] - 1
  end
end

suite.rejects("next review beyond the declared cadence", "next_review exceeds cadence_days") do |root|
  TestSupport.edit_yaml(sources(root)) do |document|
    document["freshness"]["cadence_days"] = 1
  end
end

exit(suite.run ? Standards::EXIT_SUCCESS : Standards::EXIT_INVALID)
