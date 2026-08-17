# frozen_string_literal: true

require "optparse"

module Standards
  # Command-line parsing for the validator entrypoints.
  #
  # Both validators previously read ARGV with `ARGV.include?("--release")`,
  # which accepted anything else in silence. A misspelled `--relase` ran the
  # ordinary validation and exited 0, so a release gate could appear to pass
  # without ever having run. OptionParser raises OptionParser::InvalidOption for
  # unrecognised switches; this turns that into a usage message and exit 2.
  module CLI
    # Parses +argv+ and returns an options Hash.
    #
    # The block receives the OptionParser and the options Hash so a caller can
    # declare its own switches. --help is always defined. Any leftover
    # positional argument is a usage error: neither validator takes one.
    def self.parse(argv, banner:, description: nil)
      options = {}
      parser = OptionParser.new do |parsed|
        parsed.banner = banner
        parsed.separator("")
        parsed.separator(description) if description
        parsed.separator("")
        parsed.separator("Options:")
        yield(parsed, options) if block_given?
        parsed.on("-h", "--help", "Show this message and exit") do
          puts parsed
          exit EXIT_SUCCESS
        end
      end

      begin
        rest = parser.parse(argv)
      rescue OptionParser::ParseError => e
        return usage_error(parser, e.message)
      end

      return usage_error(parser, "unexpected argument #{rest.first.inspect}") unless rest.empty?

      options
    end

    def self.usage_error(parser, message)
      warn "#{File.basename($PROGRAM_NAME)}: #{message}"
      warn parser.help
      exit EXIT_USAGE
    end
    private_class_method :usage_error
  end
end
