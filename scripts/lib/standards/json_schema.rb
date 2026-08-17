# frozen_string_literal: true

require "date"
require "json"
require "time"

module Standards
  # A JSON Schema draft 2020-12 validator covering the keyword subset the
  # schemas in schema/ actually use.
  #
  # Why this exists: the schemas were only JSON.parse'd. Nothing ever applied
  # them to a document, so every constraint they expressed was decorative and
  # free to drift away from the handwritten Ruby checks. This makes them real
  # without adding a runtime gem dependency.
  #
  # Deliberate deviations from the specification, both of which make the
  # validator stricter than a conforming implementation rather than looser:
  #
  # * `format` is asserted, not annotated. Draft 2020-12 moved `format` to the
  #   format-annotation vocabulary, where it carries no assertion unless the
  #   format-assertion vocabulary is in use. These schemas rely on `date` and
  #   `date-time` being checked, and the handwritten validator has always
  #   checked them, so this implementation asserts both.
  # * Unknown keywords raise UnsupportedKeyword instead of being ignored. A
  #   conforming implementation ignores what it does not recognise, which would
  #   let someone add a constraint to a schema that silently does nothing. Here
  #   an unimplemented keyword fails loudly the first time it is used.
  module JsonSchema
    # Raised when a schema uses a keyword this subset does not implement.
    class UnsupportedKeyword < StandardError; end

    # Keywords that carry no assertion and are safe to skip.
    ANNOTATIONS = %w[$schema $id $anchor $comment title description default examples deprecated readOnly writeOnly].freeze

    # Keywords this validator asserts.
    ASSERTIONS = %w[
      type const enum required properties additionalProperties
      items minItems maxItems uniqueItems
      minLength maxLength pattern format
      minimum maximum exclusiveMinimum exclusiveMaximum multipleOf
      allOf anyOf oneOf not if then else
      $ref $defs
    ].freeze

    TYPES = {
      "object" => Hash,
      "array" => Array,
      "string" => String,
      "boolean" => [TrueClass, FalseClass],
      "null" => NilClass
    }.freeze

    # Validates +instance+ against +schema+ and returns an Array of messages.
    # An empty Array means the instance conforms.
    #
    # +instance+ is normalised first so YAML Date and Time values compare as the
    # ISO 8601 strings the schemas describe.
    def self.validate(instance, schema, label: "")
      errors = []
      validate_node(normalize(instance), schema, schema, label, errors)
      errors
    end

    # Converts a YAML-loaded structure into its JSON data model equivalent.
    # DateTime is checked before Date because DateTime is a subclass of Date and
    # would otherwise lose its time component.
    def self.normalize(value)
      case value
      when DateTime then value.iso8601
      when Date then value.to_s
      when Time then value.utc.iso8601
      when Hash then value.each_with_object({}) { |(key, nested), result| result[key.to_s] = normalize(nested) }
      when Array then value.map { |nested| normalize(nested) }
      else value
      end
    end

    def self.validate_node(instance, schema, root, path, errors)
      # A boolean schema accepts everything (true) or nothing (false).
      case schema
      when true then return
      when false
        errors << "#{location(path)}: no value is allowed here"
        return
      end

      unless schema.is_a?(Hash)
        raise UnsupportedKeyword, "schema at #{location(path)} must be an object or boolean"
      end

      unknown = schema.keys - ANNOTATIONS - ASSERTIONS
      raise UnsupportedKeyword, "unsupported JSON Schema keyword(s) #{unknown.join(', ')} at #{location(path)}" unless unknown.empty?

      if schema.key?("$ref")
        validate_node(instance, resolve_ref(schema["$ref"], root), root, path, errors)
        # 2020-12 allows siblings of $ref; the schemas here never use them, and
        # the keyword loop below still runs so any that appear are applied.
      end

      check_type(instance, schema, path, errors)
      check_enumerations(instance, schema, path, errors)
      check_string(instance, schema, path, errors)
      check_number(instance, schema, path, errors)
      check_array(instance, schema, root, path, errors)
      check_object(instance, schema, root, path, errors)
      check_combinators(instance, schema, root, path, errors)
    end

    def self.check_type(instance, schema, path, errors)
      expected = schema["type"]
      return if expected.nil?

      types = Array(expected)
      return if types.any? { |type| type?(instance, type) }

      errors << "#{location(path)}: expected #{types.join(' or ')}, got #{describe(instance)}"
    end

    def self.type?(instance, type)
      case type
      when "integer" then instance.is_a?(Integer)
      when "number" then instance.is_a?(Numeric) && !instance.is_a?(TrueClass)
      else
        expected = TYPES.fetch(type) { raise UnsupportedKeyword, "unsupported JSON Schema type #{type.inspect}" }
        Array(expected).any? { |klass| instance.is_a?(klass) }
      end
    end

    def self.check_enumerations(instance, schema, path, errors)
      if schema.key?("const") && instance != schema["const"]
        errors << "#{location(path)}: must be #{schema['const'].inspect}, got #{instance.inspect}"
      end

      return unless schema.key?("enum")
      return if schema["enum"].include?(instance)

      errors << "#{location(path)}: #{instance.inspect} is not one of #{schema['enum'].map(&:inspect).join(', ')}"
    end

    def self.check_string(instance, schema, path, errors)
      return unless instance.is_a?(String)

      minimum = schema["minLength"]
      maximum = schema["maxLength"]
      errors << "#{location(path)}: must be at least #{minimum} characters" if minimum && instance.length < minimum
      errors << "#{location(path)}: must be at most #{maximum} characters" if maximum && instance.length > maximum

      if (pattern = schema["pattern"]) && !Regexp.new(pattern).match?(instance)
        errors << "#{location(path)}: #{instance.inspect} does not match #{pattern}"
      end

      check_format(instance, schema["format"], path, errors) if schema["format"]
    end

    def self.check_format(instance, format, path, errors)
      case format
      when "date"
        Date.iso8601(instance)
        # Date.iso8601 accepts week and ordinal dates; the schemas mean calendar
        # dates, which is what every consumer of these fields parses.
        unless instance.match?(/\A\d{4}-\d{2}-\d{2}\z/)
          errors << "#{location(path)}: #{instance.inspect} is not an ISO 8601 calendar date"
        end
      when "date-time"
        Time.iso8601(instance)
      when "uri"
        errors << "#{location(path)}: #{instance.inspect} is not an absolute URI" unless instance.match?(%r{\A[a-z][a-z0-9+.-]*:}i)
      else
        raise UnsupportedKeyword, "unsupported JSON Schema format #{format.inspect} at #{location(path)}"
      end
    rescue ArgumentError
      errors << "#{location(path)}: #{instance.inspect} is not an ISO 8601 #{format}"
    end

    def self.check_number(instance, schema, path, errors)
      return unless instance.is_a?(Numeric) && !instance.is_a?(TrueClass)

      errors << "#{location(path)}: must be >= #{schema['minimum']}" if schema["minimum"] && instance < schema["minimum"]
      errors << "#{location(path)}: must be <= #{schema['maximum']}" if schema["maximum"] && instance > schema["maximum"]
      errors << "#{location(path)}: must be > #{schema['exclusiveMinimum']}" if schema["exclusiveMinimum"] && instance <= schema["exclusiveMinimum"]
      errors << "#{location(path)}: must be < #{schema['exclusiveMaximum']}" if schema["exclusiveMaximum"] && instance >= schema["exclusiveMaximum"]
      if (step = schema["multipleOf"]) && (instance % step) != 0
        errors << "#{location(path)}: must be a multiple of #{step}"
      end
    end

    def self.check_array(instance, schema, root, path, errors)
      return unless instance.is_a?(Array)

      minimum = schema["minItems"]
      maximum = schema["maxItems"]
      errors << "#{location(path)}: must have at least #{minimum} item(s), got #{instance.length}" if minimum && instance.length < minimum
      errors << "#{location(path)}: must have at most #{maximum} item(s), got #{instance.length}" if maximum && instance.length > maximum

      if schema["uniqueItems"] && instance.length != instance.uniq.length
        duplicates = instance.tally.select { |_item, count| count > 1 }.keys
        errors << "#{location(path)}: items must be unique, repeated #{duplicates.map(&:inspect).join(', ')}"
      end

      return unless schema.key?("items")

      instance.each_with_index do |item, index|
        validate_node(item, schema["items"], root, "#{path}[#{index}]", errors)
      end
    end

    def self.check_object(instance, schema, root, path, errors)
      return unless instance.is_a?(Hash)

      Array(schema["required"]).each do |key|
        errors << "#{location(path)}: missing required property #{key}" unless instance.key?(key)
      end

      properties = schema["properties"] || {}
      properties.each do |key, subschema|
        next unless instance.key?(key)

        validate_node(instance[key], subschema, root, path.empty? ? key : "#{path}.#{key}", errors)
      end

      return unless schema.key?("additionalProperties")

      extra = instance.keys - properties.keys
      return if extra.empty?

      if schema["additionalProperties"] == false
        errors << "#{location(path)}: unknown propert#{extra.length == 1 ? 'y' : 'ies'} #{extra.sort.join(', ')}"
      else
        extra.each do |key|
          validate_node(instance[key], schema["additionalProperties"], root, path.empty? ? key : "#{path}.#{key}", errors)
        end
      end
    end

    def self.check_combinators(instance, schema, root, path, errors)
      Array(schema["allOf"]).each do |subschema|
        validate_node(instance, subschema, root, path, errors)
      end

      if schema.key?("anyOf")
        branches = schema["anyOf"].map { |subschema| collect(instance, subschema, root, path) }
        if branches.none?(&:empty?)
          errors << "#{location(path)}: does not match any allowed variant (#{branches.flatten.uniq.join('; ')})"
        end
      end

      if schema.key?("oneOf")
        branches = schema["oneOf"].map { |subschema| collect(instance, subschema, root, path) }
        matched = branches.count(&:empty?)
        if matched.zero?
          errors << "#{location(path)}: does not match any allowed variant (#{branches.flatten.uniq.join('; ')})"
        elsif matched > 1
          errors << "#{location(path)}: matches #{matched} variants but must match exactly one"
        end
      end

      if schema.key?("not") && collect(instance, schema["not"], root, path).empty?
        errors << "#{location(path)}: must not match the excluded schema"
      end

      return unless schema.key?("if")

      if collect(instance, schema["if"], root, path).empty?
        validate_node(instance, schema["then"], root, path, errors) if schema.key?("then")
      elsif schema.key?("else")
        validate_node(instance, schema["else"], root, path, errors)
      end
    end

    # Runs a subschema for its result without contributing to the caller's
    # errors, which is what the combinators need to test a branch.
    def self.collect(instance, schema, root, path)
      branch = []
      validate_node(instance, schema, root, path, branch)
      branch
    end

    def self.resolve_ref(reference, root)
      unless reference.start_with?("#/")
        raise UnsupportedKeyword, "only local JSON pointer references are supported, got #{reference.inspect}"
      end

      reference.delete_prefix("#/").split("/").reduce(root) do |node, token|
        key = token.gsub("~1", "/").gsub("~0", "~")
        unless node.is_a?(Hash) && node.key?(key)
          raise UnsupportedKeyword, "unresolvable reference #{reference.inspect}"
        end

        node[key]
      end
    end

    def self.location(path)
      path.empty? ? "(root)" : path
    end

    def self.describe(instance)
      case instance
      when nil then "null"
      when true, false then "boolean"
      when Integer then "integer"
      when Numeric then "number"
      when String then "string"
      when Array then "array"
      when Hash then "object"
      else instance.class.name
      end
    end

    private_class_method :validate_node, :check_type, :type?, :check_enumerations, :check_string,
                         :check_format, :check_number, :check_array, :check_object,
                         :check_combinators, :collect, :resolve_ref, :location, :describe
  end
end
