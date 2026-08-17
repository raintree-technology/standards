# frozen_string_literal: true

require "date"
require "fileutils"
require "open3"
require "rbconfig"
require "tmpdir"
require "yaml"

require_relative "document"

module Standards
  # Shared harness for the validator test suites.
  #
  # Both suites previously carried their own copies of replace_once,
  # assert_rejected, and the case registry, and both mutated fixtures by
  # substituting exact strings -- review dates, generated timestamps, and
  # sentences lifted out of capability prose. Any ordinary content edit broke
  # tests that had nothing to do with the change. The helpers here edit YAML
  # and front matter structurally, so a case survives content edits and fails
  # only when the rule it covers stops working.
  module TestSupport
    REPOSITORY_ROOT = File.expand_path("../../..", __dir__)

    # Raised when a fixture mutation cannot be applied, which means the test is
    # out of date rather than the validator being wrong.
    class FixtureError < StandardError; end

    # A registered set of validator invocations and their expected outcomes.
    class Suite
      Result = Struct.new(:stdout, :stderr, :status, keyword_init: true) do
        def output
          "#{stdout}\n#{stderr}"
        end

        def success?
          status.success?
        end

        def code
          status.exitstatus
        end
      end

      attr_reader :cases

      # +validator+ is the script under test; +root_env+ is the environment
      # variable it reads its bundle root from.
      def initialize(name, validator:, root_env:, prepare:)
        @name = name
        @validator = File.join(REPOSITORY_ROOT, "scripts", validator)
        @root_env = root_env
        @prepare = prepare
        @cases = []
      end

      # Registers a case expecting a non-zero exit and +expected+ in the output.
      def rejects(name, expected, argv: [], &mutation)
        @cases << { name: name, expect: :reject, expected: Array(expected), argv: argv, mutation: mutation }
      end

      # Registers a case expecting exit 0 and +expected+ in the output. Positive
      # cases matter as much as negative ones: they catch a validator that has
      # started rejecting valid input, which no rejection case can detect.
      def accepts(name, expected = nil, argv: [], &mutation)
        @cases << { name: name, expect: :accept, expected: Array(expected), argv: argv, mutation: mutation }
      end

      # Registers a case expecting the usage exit status (2).
      def rejects_usage(name, expected, argv)
        @cases << { name: name, expect: :usage, expected: Array(expected), argv: argv, mutation: nil }
      end

      # Registers a case that must exit 0 and must NOT contain +forbidden+.
      def accepts_without(name, forbidden, argv: [], &mutation)
        @cases << { name: name, expect: :accept, expected: [], forbidden: Array(forbidden), argv: argv, mutation: mutation }
      end

      def run(io: $stdout)
        failures = @cases.filter_map { |test_case| failure_for(test_case) }

        unless failures.empty?
          failures.each { |message| warn message }
          warn "#{@name}: #{failures.length} of #{@cases.length} cases failed"
          return false
        end

        io.puts "#{@name}: #{@cases.length} cases"
        true
      end

      private

      def failure_for(test_case)
        result = nil
        Dir.mktmpdir("standards-validator-") do |root|
          @prepare.call(root)
          test_case[:mutation]&.call(root)
          result = invoke(root, test_case.fetch(:argv, []))
        end

        check(test_case, result)
      rescue FixtureError => e
        "#{test_case[:name]}: #{e.message}"
      end

      def check(test_case, result)
        case test_case[:expect]
        when :reject
          return "#{test_case[:name]}: validator unexpectedly passed" if result.success?
          return "#{test_case[:name]}: expected exit 1, got #{result.code}" unless result.code == 1
        when :usage
          return "#{test_case[:name]}: expected usage exit 2, got #{result.code}" unless result.code == 2
        when :accept
          unless result.success?
            return "#{test_case[:name]}: validator unexpectedly failed with #{result.output.strip.inspect}"
          end
        end

        present = Array(test_case[:forbidden]).select { |fragment| result.output.include?(fragment) }
        unless present.empty?
          return "#{test_case[:name]}: unexpected #{present.map(&:inspect).join(', ')} in #{result.output.strip.inspect}"
        end

        missing = test_case[:expected].reject { |fragment| result.output.include?(fragment) }
        return nil if missing.empty?

        "#{test_case[:name]}: expected #{missing.map(&:inspect).join(', ')} in #{result.output.strip.inspect}"
      end

      def invoke(root, argv)
        stdout, stderr, status = Open3.capture3(
          { @root_env => root },
          RbConfig.ruby,
          @validator,
          *argv
        )
        Result.new(stdout: stdout, stderr: stderr, status: status)
      end
    end

    # -- fixture preparation -------------------------------------------------

    # Copies the working tree, minus .git, into +target+.
    def self.copy_repository(target)
      Dir.children(REPOSITORY_ROOT).each do |name|
        next if name == ".git"

        FileUtils.cp_r(File.join(REPOSITORY_ROOT, name), File.join(target, name))
      end
    end

    # Copies only what the integration validator reads.
    def self.copy_integration_bundle(target)
      integrations = File.join(target, "integrations")
      FileUtils.mkdir_p(integrations)
      FileUtils.mkdir_p(File.join(target, "schema"))
      Dir.glob(File.join(REPOSITORY_ROOT, "integrations", "*", "manifest.yaml")).sort.each do |manifest|
        source = File.dirname(manifest)
        FileUtils.cp_r(source, File.join(integrations, File.basename(source)))
      end
      %w[integration-capability.schema.json integration-manifest.schema.json].each do |name|
        FileUtils.cp(File.join(REPOSITORY_ROOT, "schema", name), File.join(target, "schema"))
      end
    end

    # -- fixture mutation ----------------------------------------------------

    # An independent copy of a parsed YAML structure.
    #
    # Hash#dup is shallow, so appending a shallow copy makes the two rows share
    # their nested objects and Psych serialises the second one as a YAML alias.
    # The validators disable aliases, so such a fixture fails on the alias
    # instead of on the duplicate the case is about.
    def self.deep_copy(value)
      Marshal.load(Marshal.dump(value))
    end

    # Loads a YAML file, yields the parsed structure for mutation, and writes it
    # back. Structural editing keeps a case independent of the file's current
    # dates, ordering, and formatting.
    def self.edit_yaml(path)
      document = YAML.safe_load(File.read(path), permitted_classes: [Date, Time], aliases: false)
      raise FixtureError, "#{path} is not a YAML mapping" unless document.is_a?(Hash)

      yield(document)
      File.write(path, document.to_yaml)
      document
    end

    # Rewrites only the YAML front matter of a Markdown file, leaving the body
    # untouched.
    def self.edit_front_matter(path)
      content = File.read(path)
      raw = content[Document::FRONT_MATTER, 1]
      raise FixtureError, "#{path} has no YAML front matter" if raw.nil?

      metadata = YAML.safe_load(raw, permitted_classes: [Date, Time], aliases: false)
      raise FixtureError, "#{path} front matter is not a mapping" unless metadata.is_a?(Hash)

      yield(metadata)
      body = content.sub(Document::FRONT_MATTER, "")
      File.write(path, "#{metadata.to_yaml}---\n#{body}")
    end

    # Replaces the whole front-matter block with literal text, for cases that
    # are about malformed YAML and cannot be expressed structurally.
    def self.replace_front_matter(path, raw)
      content = File.read(path)
      raise FixtureError, "#{path} has no YAML front matter" unless content.match?(Document::FRONT_MATTER)

      File.write(path, content.sub(Document::FRONT_MATTER, "---\n#{raw}\n---\n"))
    end

    # Appends a raw line inside an existing front-matter block. Used only for
    # duplicate-key cases, which have no structural representation because
    # Psych keeps just the last value.
    def self.append_front_matter_line(path, line)
      content = File.read(path)
      raw = content[Document::FRONT_MATTER, 1]
      raise FixtureError, "#{path} has no YAML front matter" if raw.nil?

      File.write(path, content.sub(Document::FRONT_MATTER, "---\n#{raw}\n#{line}\n---\n"))
    end

    # The first governed entry of a catalog section, so cases refer to "some
    # foundation" rather than naming one that may later move or be retired.
    def self.first_entry(root, section)
      catalog = YAML.safe_load(File.read(File.join(root, "catalog.yaml")), permitted_classes: [Date], aliases: false)
      entry = Array(catalog[section]).find { |row| row.is_a?(Hash) && row["path"] }
      raise FixtureError, "catalog.yaml has no usable #{section} entry" if entry.nil?

      entry
    end

    # A capability row matching +predicate+, addressed by role rather than by ID.
    def self.find_row(path, key, &predicate)
      document = YAML.safe_load(File.read(path), permitted_classes: [Date], aliases: false)
      row = Array(document[key]).find(&predicate)
      raise FixtureError, "#{path} has no #{key} row matching the test's criteria" if row.nil?

      row
    end
  end
end
