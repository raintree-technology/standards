#!/usr/bin/env ruby
# frozen_string_literal: true

# Validates the governed vendor integration capability bundles.
#
# Exit statuses: 0 valid, 1 validation failed, 2 usage error.

require_relative "lib/standards"
require_relative "lib/standards/integration_validator"

Standards::CLI.parse(
  ARGV,
  banner: "Usage: ruby scripts/validate_integrations.rb [options]",
  description: "Validates the integration capability bundle against its schema and cross-file rules."
)

root = ENV["INTEGRATION_VALIDATION_ROOT"].to_s.empty? ? File.expand_path("..", __dir__) : File.expand_path(ENV.fetch("INTEGRATION_VALIDATION_ROOT"))

validator = Standards::IntegrationValidator.new(root)

# A missing artifact stops the run: every later pass would only restate it.
unless validator.artifacts_present?
  validator.findings.report
  exit Standards::EXIT_INVALID
end

validator.run

if validator.valid?
  puts validator.summary_lines
  exit Standards::EXIT_SUCCESS
end

validator.findings.report
exit Standards::EXIT_INVALID
