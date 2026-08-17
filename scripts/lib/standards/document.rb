# frozen_string_literal: true

require_relative "yaml_source"

module Standards
  # Reading Markdown documents that carry OKF YAML front matter.
  #
  # Each governed document used to be read from disk three or four times, once
  # per validation pass, and its front matter parsed each time. Document reads
  # and parses once and the passes share the result.
  class Document
    FRONT_MATTER = /\A---\s*\n(.*?)\n---\s*\n/m

    attr_reader :relative, :content, :metadata

    # Loads the document at +absolute+ and parses its front matter.
    #
    # +metadata+ is nil when the file has no front matter or the front matter is
    # not a mapping; +front_matter?+ distinguishes "absent" from "unparseable"
    # so callers can report the right thing.
    def self.load(absolute, relative, findings, permitted_classes: YamlSource::PERMITTED_CLASSES)
      new(relative, File.read(absolute), findings, permitted_classes: permitted_classes)
    end

    def initialize(relative, content, findings, permitted_classes: YamlSource::PERMITTED_CLASSES)
      @relative = relative
      @content = content
      @findings = findings
      @raw_front_matter = content[FRONT_MATTER, 1]
      @metadata = parse_front_matter(permitted_classes)
    end

    def front_matter?
      !@raw_front_matter.nil?
    end

    def metadata?
      @metadata.is_a?(Hash)
    end

    # Every Markdown link target in the document, as written.
    def link_targets
      @content.scan(/\[[^\]]+\]\(([^)]+)\)/).flatten
    end

    # Body text following the given `## Heading`, up to the next `## ` heading.
    #
    # Bounding at the next heading matters: scanning to end-of-file pulled links
    # from later sections into the Sources comparison.
    def section(heading)
      pattern = /^##\s+#{Regexp.escape(heading)}\s*$\n(.*?)(?=^##\s|\z)/m
      @content[pattern, 1]
    end

    def heading?(level, text)
      @content.match?(/^#{'#' * level}\s+#{Regexp.escape(text)}\s*$/)
    end

    private

    def parse_front_matter(permitted_classes)
      return nil unless front_matter?

      label = "#{@relative}: front matter"
      tree = Psych.parse_stream(@raw_front_matter)
      return nil unless YamlSource.duplicate_keys(tree, label, @findings)
      parsed = YAML.safe_load(@raw_front_matter, permitted_classes: permitted_classes, aliases: false)
      return parsed if parsed.is_a?(Hash)

      @findings.add("#{@relative}: YAML front matter must be a mapping")
      nil
    rescue Psych::Exception => e
      @findings.add("#{@relative}: invalid YAML front matter (#{YamlSource.first_line(e)})")
      nil
    end
  end
end
