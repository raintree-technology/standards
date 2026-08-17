# frozen_string_literal: true

# Shared support for the raintree.standards validators.
#
# Every entrypoint requires this file first. It enforces the supported Ruby
# floor before any other library code loads, so an unsupported interpreter
# reports one actionable line instead of a syntax error from a deeper file.

module Standards
  # Oldest interpreter the validators are tested against, and therefore the
  # oldest one whose behaviour the code is allowed to assume. CI pins the exact
  # version in .ruby-version; this is the floor, not the target.
  MINIMUM_RUBY = "3.1.0"

  # Exit statuses are part of the command contract. Callers distinguish a bundle
  # that failed validation from an invocation that was never valid to begin with.
  EXIT_SUCCESS = 0
  EXIT_INVALID = 1
  EXIT_USAGE = 2
end

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new(Standards::MINIMUM_RUBY)
  warn "raintree.standards validators require Ruby #{Standards::MINIMUM_RUBY} or newer; this is Ruby #{RUBY_VERSION}."
  warn "Install the version in .ruby-version (for example: mise use ruby@3.4) and re-run from the repository root."
  exit Standards::EXIT_USAGE
end

require_relative "standards/findings"
require_relative "standards/paths"
require_relative "standards/input_limits"
require_relative "standards/yaml_source"
require_relative "standards/document"
require_relative "standards/json_schema"
require_relative "standards/cli"
