#!/usr/bin/env ruby
# frozen_string_literal: true

# Validates the OKF v0.2 bundle, the governed catalog, and the source register.
#
# Exit statuses: 0 valid, 1 validation failed, 2 usage error.

require_relative "lib/standards"
require_relative "lib/standards/catalog_validator"

options = Standards::CLI.parse(
  ARGV,
  banner: "Usage: ruby scripts/validate_catalog.rb [options]",
  description: "Validates the OKF bundle, the governed catalog, and the source register."
) do |parser, parsed|
  parser.on("--release", "Also apply the pre-release gate (drafts, verification, dependencies)") do
    parsed[:release] = true
  end
end

root = ENV["CATALOG_VALIDATION_ROOT"].to_s.empty? ? File.expand_path("..", __dir__) : File.expand_path(ENV.fetch("CATALOG_VALIDATION_ROOT"))

begin
  validator = Standards::CatalogValidator.new(root, release: options.fetch(:release, false)).run
rescue Standards::JsonSchema::UnsupportedKeyword => e
  warn "schema: #{e.message}"
  exit Standards::EXIT_INVALID
end

if validator.valid?
  puts validator.summary_lines
  exit Standards::EXIT_SUCCESS
end

validator.findings.report
validator.release_blockers.report if validator.release?
exit Standards::EXIT_INVALID
