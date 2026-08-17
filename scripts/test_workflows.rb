#!/usr/bin/env ruby
# frozen_string_literal: true

# Checks the GitHub Actions workflows against the constraints this repository
# actually operates under.
#
# These are cheap to assert and expensive to discover the other way. A workflow
# referencing an action this repository is not allowed to run fails at startup
# with no step output and no log, which is easy to miss unless someone watches
# the run after pushing. Pinning and permissions are policy requirements that a
# reviewer should not have to check by eye.

require "yaml"

require_relative "lib/standards"

ROOT = File.expand_path("..", __dir__)
WORKFLOW_DIR = File.join(ROOT, ".github", "workflows")

# The repository sets allowed_actions to "selected" with github_owned_allowed
# true, so actions/* are permitted and everything else must appear in the
# allowlist. Mirroring the non-GitHub entries here means adding an action is a
# deliberate step rather than something discovered from a startup failure.
# Read the live policy with:
#   gh api repos/OWNER/REPO/actions/permissions/selected-actions
ALLOWED_NON_GITHUB_ACTIONS = %w[
  jdx/mise-action
].freeze

# sha_pinning_required is true for this repository.
SHA_PIN = /\A[0-9a-f]{40}\z/

failures = []
checks = 0

def check(failures, condition, message)
  failures << message unless condition
end

workflows = Dir.glob(File.join(WORKFLOW_DIR, "*.yml")).sort
if workflows.empty?
  warn "No workflows found in .github/workflows"
  exit Standards::EXIT_INVALID
end

workflows.each do |path|
  relative = path.delete_prefix("#{ROOT}/")

  checks += 1
  document = begin
    YAML.safe_load(File.read(path), aliases: false)
  rescue Psych::Exception => e
    failures << "#{relative}: does not parse (#{e.message.lines.first.to_s.strip})"
    nil
  end
  next if document.nil?

  # Least privilege has to be stated; an unset permissions block inherits
  # whatever the organization default happens to be.
  checks += 1
  check(failures, document.key?("permissions"), "#{relative}: does not declare a permissions block")

  jobs = document["jobs"] || {}
  jobs.each do |name, job|
    checks += 1
    check(failures, !job["runs-on"].to_s.include?("latest"),
          "#{relative}: job #{name} uses a floating runner label #{job['runs-on'].inspect}")

    checks += 1
    check(failures, job.key?("timeout-minutes"), "#{relative}: job #{name} declares no timeout-minutes")
  end

  # Every `uses:` must be SHA-pinned, carry a readable version comment, and be
  # an action this repository is allowed to run.
  File.readlines(path).each_with_index do |line, index|
    match = line.match(/^\s*uses:\s*(\S+)/)
    next if match.nil?

    location = "#{relative}:#{index + 1}"
    reference = match[1]
    action, _, pin = reference.partition("@")

    checks += 1
    check(failures, pin.match?(SHA_PIN),
          "#{location}: #{reference} is not pinned to a full commit SHA")

    checks += 1
    check(failures, line.match?(/#\s*v\S+/),
          "#{location}: #{action} has no version comment beside its SHA")

    checks += 1
    permitted = action.start_with?("actions/") || ALLOWED_NON_GITHUB_ACTIONS.include?(action)
    check(failures, permitted,
          "#{location}: #{action} is not in this repository's actions allowlist, so the workflow would fail at startup")
  end
end

# -- CI and documentation must run the same checks ---------------------------

# CONTRIBUTING.md tells contributors what to run before opening a pull request.
# If CI runs a different set, one of the two is lying, and the usual direction
# is that a newly added suite never makes it into the documented list.
contributing = File.read(File.join(ROOT, "CONTRIBUTING.md"))
documented = contributing[/^## Run the checks\s*$(.*?)^## /m, 1].to_s
                          .scan(/^ruby (scripts\/\S+\.rb)$/).flatten

workflow_commands = File.read(File.join(WORKFLOW_DIR, "validate.yml"))
                        .scan(/^\s*run:\s*ruby (scripts\/\S+\.rb)\s*$/).flatten

checks += 1
check(failures, !documented.empty?, "CONTRIBUTING.md: found no documented validator commands to compare against CI")

checks += 1
check(failures, documented == workflow_commands,
      "CONTRIBUTING.md and .github/workflows/validate.yml run different checks:\n" \
      "  documented: #{documented.join(', ')}\n" \
      "  workflow:   #{workflow_commands.join(', ')}")

# Every executable suite in scripts/ should be one CI actually runs, otherwise
# it rots unnoticed.
suites = Dir.glob(File.join(ROOT, "scripts", "test_*.rb")).sort.map { |path| "scripts/#{File.basename(path)}" }
checks += 1
missing = suites - workflow_commands
check(failures, missing.empty?, "these suites exist but CI never runs them: #{missing.join(', ')}")

if failures.empty?
  puts "Workflow checks valid: #{checks} assertions across #{workflows.length} workflow(s)"
  exit Standards::EXIT_SUCCESS
end

failures.each { |message| warn message }
warn "Workflow checks: #{failures.length} of #{checks} assertions failed"
exit Standards::EXIT_INVALID
