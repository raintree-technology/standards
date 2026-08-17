# frozen_string_literal: true

require "yaml"

module YamlValidation
  def self.find_duplicate_keys(node, path, errors)
    case node
    when Psych::Nodes::Mapping
      seen = {}
      node.children.each_slice(2) do |key_node, value_node|
        key = key_node.respond_to?(:value) ? key_node.value : key_node.to_s
        errors << "#{path}: duplicate YAML mapping key #{key.inspect}" if seen.key?(key)
        seen[key] = true
        find_duplicate_keys(value_node, "#{path}.#{key}", errors)
      end
    when Psych::Nodes::Sequence, Psych::Nodes::Document, Psych::Nodes::Stream
      node.children.each_with_index { |child, index| find_duplicate_keys(child, "#{path}[#{index}]", errors) }
    end
  end
end
