# frozen_string_literal: true

require "date"
require "time"
require "yaml"

module Standards
  # Safe YAML loading for validator input.
  #
  # Every load here goes through Psych.safe_load with aliases disabled and an
  # explicit permitted-class list, per the Psych documentation's guidance that
  # Psych.load and Psych.unsafe_load must never see untrusted input. Anything
  # Psych rejects (syntax errors, disallowed classes, aliases) arrives as a
  # Psych::Exception and is turned into a validation message rather than a
  # stack trace.
  module YamlSource
    # Front matter and data files legitimately carry ISO dates and timestamps.
    # Psych builds Date for `2026-08-16` and Time for `2026-08-16T23:26:21Z`.
    PERMITTED_CLASSES = [Date, Time].freeze
    MAX_DEPTH = 100
    MAX_NODES = 100_000

    # Reports every duplicate mapping key in a parsed node tree.
    #
    # YAML itself allows duplicate keys and Psych silently keeps the last one,
    # so a typo can drop a rule without any parser complaint. This walks the
    # node tree, which is the only place the duplicates are still visible.
    def self.duplicate_keys(node, path, findings, max_depth: MAX_DEPTH, max_nodes: MAX_NODES)
      stack = [[node, path, 0]]
      nodes = 0

      until stack.empty?
        current, current_path, depth = stack.pop
        nodes += 1
        if nodes > max_nodes
          findings.add("#{path}: YAML structure exceeds the #{max_nodes}-node limit")
          return false
        end
        if depth > max_depth
          findings.add("#{path}: YAML structure exceeds the maximum depth of #{max_depth}")
          return false
        end

        case current
        when Psych::Nodes::Mapping
          seen = {}
          current.children.each_slice(2).reverse_each do |key_node, value_node|
            key = key_node.respond_to?(:value) ? key_node.value : key_node.to_s
            findings.add("#{current_path}: duplicate YAML mapping key #{key.inspect}") if seen.key?(key)
            seen[key] = true
            stack << [value_node, "#{current_path}.#{key}", depth + 1]
            stack << [key_node, current_path, depth + 1]
          end
        when Psych::Nodes::Sequence
          current.children.each_with_index.reverse_each do |child, index|
            stack << [child, "#{current_path}[#{index}]", depth + 1]
          end
        when Psych::Nodes::Document, Psych::Nodes::Stream
          # Stream and document nodes are parser structure, not addressable data.
          current.children.reverse_each { |child| stack << [child, current_path, depth] }
        end
      end

      true
    end

    # Parses +content+ and always returns a Hash.
    #
    # Anything that is not a mapping -- a sequence, a bare scalar, an empty
    # document that parses to nil -- becomes a finding and an empty Hash, so
    # callers can index the result without a nil or TypeError check at every
    # use site.
    def self.load_mapping(content, label, findings, permitted_classes: PERMITTED_CLASSES, check_duplicates: true)
      if check_duplicates
        tree = Psych.parse_stream(content)
        return {} unless duplicate_keys(tree, label, findings)
      end
      document = YAML.safe_load(content, permitted_classes: permitted_classes, aliases: false)
      return document if document.is_a?(Hash)

      findings.add("#{label}: top level must be a mapping")
      {}
    rescue Psych::Exception => e
      findings.add("#{label}: invalid YAML (#{first_line(e)})")
      {}
    end

    # load_mapping for a file on disk. A missing or unreadable file is a
    # finding, not an exception.
    def self.load_file(path, label, findings, permitted_classes: PERMITTED_CLASSES)
      load_mapping(File.read(path), label, findings, permitted_classes: permitted_classes)
    rescue Errno::ENOENT
      findings.add("Missing #{label}")
      {}
    rescue SystemCallError => e
      findings.add("#{label}: cannot be read (#{e.message})")
      {}
    end

    # Rows of a list-valued field, keeping only the entries that are mappings.
    #
    # Reporting the non-mapping entries and dropping them means the per-row
    # checks downstream never index a String or Integer, which previously
    # raised TypeError and aborted the whole run.
    def self.mapping_rows(value, label, findings)
      unless value.nil? || value.is_a?(Array)
        findings.add("#{label} must be a list")
        return []
      end

      Array(value).each_with_index.each_with_object([]) do |(row, index), rows|
        if row.is_a?(Hash)
          rows << row
        else
          findings.add("#{label}[#{index}] must be a mapping")
        end
      end
    end

    # Psych messages carry the offending snippet on later lines; validator
    # output stays one line per finding.
    def self.first_line(error)
      error.message.to_s.lines.first.to_s.strip
    end
  end
end
