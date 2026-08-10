#!/usr/bin/env ruby

require "date"
require "time"
require "yaml"

ROOT = File.expand_path("..", __dir__)
CATALOG = File.join(ROOT, "catalog.yaml")
errors = []
actor_pattern = /\A(?:human:[^\s]+|process:[^\s]+|[^\s:\/]+\/[^\s\/]+)\z/

valid_date = lambda do |value|
  value.is_a?(Date) || (value.is_a?(String) && Date.iso8601(value))
rescue Date::Error
  false
end

valid_datetime = lambda do |value|
  value.is_a?(Time) || (value.is_a?(String) && Time.iso8601(value))
rescue ArgumentError
  false
end

catalog = YAML.safe_load(File.read(CATALOG), permitted_classes: [Date], aliases: false)
entries = %w[foundations standards profiles].flat_map { |key| catalog.fetch(key, []) }
ids = {}

errors << "catalog.yaml: okf_version must be 0.2" unless catalog["okf_version"] == "0.2"
errors << "catalog.yaml: bundle_index must be index.md" unless catalog["bundle_index"] == "index.md"

catalog_entries = %w[governance foundations standards profiles].flat_map { |key| catalog.fetch(key, []) }
catalog_paths = catalog_entries.map { |entry| entry["path"] }
catalog_paths.each do |relative|
  if relative.to_s.empty?
    errors << "catalog.yaml: every entry requires a path"
  elsif !File.file?(File.join(ROOT, relative))
    errors << "catalog.yaml: missing path #{relative}"
  end
end
path_counts = Hash.new(0)
catalog_paths.compact.each { |path| path_counts[path] += 1 }
path_counts.each do |path, count|
  errors << "catalog.yaml: duplicate path #{path}" if count > 1
end

entries.each do |entry|
  path = File.join(ROOT, entry.fetch("path"))
  unless File.file?(path)
    errors << "Missing catalog path: #{entry['path']}"
    next
  end

  content = File.read(path)
  match = content.match(/\A---\s*\n(.*?)\n---\s*\n/m)
  unless match
    errors << "Missing YAML front matter: #{entry['path']}"
    next
  end

  metadata = YAML.safe_load(match[1], permitted_classes: [Date], aliases: false)
  %w[id title description type status governance_status owners last_reviewed applies_to tags generated].each do |field|
    errors << "#{entry['path']}: missing #{field}" unless metadata.key?(field)
  end

  errors << "#{entry['path']}: invalid OKF status #{metadata['status']}" unless %w[draft stable deprecated].include?(metadata["status"])
  errors << "#{entry['path']}: invalid document ID" unless metadata["id"].to_s.match?(/\A[A-Z][A-Z0-9]*(?:-[A-Z0-9]+)+\z/)
  errors << "#{entry['path']}: invalid Raintree document type #{metadata['type']}" unless %w[foundation standard pattern playbook profile decision].include?(metadata["type"])
  errors << "#{entry['path']}: description must contain at least 3 characters" unless metadata["description"].is_a?(String) && metadata["description"].length >= 3
  errors << "#{entry['path']}: owners must be a non-empty list" unless metadata["owners"].is_a?(Array) && metadata["owners"].all? { |owner| owner.is_a?(String) && !owner.empty? } && !metadata["owners"].empty?
  errors << "#{entry['path']}: applies_to must be a unique list" unless metadata["applies_to"].is_a?(Array) && metadata["applies_to"].uniq.length == metadata["applies_to"].length
  errors << "#{entry['path']}: tags must be a unique list" unless metadata["tags"].is_a?(Array) && metadata["tags"].uniq.length == metadata["tags"].length
  errors << "#{entry['path']}: depends_on must be a unique list" unless metadata["depends_on"].nil? || (metadata["depends_on"].is_a?(Array) && metadata["depends_on"].uniq.length == metadata["depends_on"].length)
  errors << "#{entry['path']}: invalid last_reviewed date" unless valid_date.call(metadata["last_reviewed"])

  lifecycle_map = {
    "draft" => "draft",
    "active" => "stable",
    "deprecated" => "deprecated",
    "retired" => "deprecated"
  }
  expected_status = lifecycle_map[metadata["governance_status"]]
  if expected_status.nil?
    errors << "#{entry['path']}: invalid governance_status #{metadata['governance_status']}"
  elsif metadata["status"] != expected_status
    errors << "#{entry['path']}: status #{metadata['status']} conflicts with governance_status #{metadata['governance_status']}"
  end

  generated = metadata["generated"]
  unless generated.is_a?(Hash) && generated["by"].to_s.length.positive? && generated["at"]
    errors << "#{entry['path']}: generated requires by and at"
  end

  if metadata["review_by"] && metadata["stale_after"] != metadata["review_by"]
    errors << "#{entry['path']}: stale_after must match review_by"
  end

  catalog_id = entry["id"]
  document_id = metadata["id"]
  if catalog_id && catalog_id != document_id
    errors << "#{entry['path']}: catalog ID #{catalog_id} does not match #{document_id}"
  end

  if ids.key?(document_id)
    errors << "Duplicate document ID #{document_id}: #{ids[document_id]} and #{entry['path']}"
  else
    ids[document_id] = entry["path"]
  end

end

entries.each do |entry|
  path = File.join(ROOT, entry.fetch("path"))
  next unless File.file?(path)

  match = File.read(path).match(/\A---\s*\n(.*?)\n---\s*\n/m)
  next unless match

  metadata = YAML.safe_load(match[1], permitted_classes: [Date], aliases: false)
  Array(metadata["depends_on"]).each do |dependency|
    errors << "#{entry['path']}: unknown dependency #{dependency}" unless ids.key?(dependency)
  end
end

markdown_files = Dir.glob(File.join(ROOT, "**", "*.md"))
markdown_files.each do |file|
  content = File.read(file)
  relative = file.delete_prefix(ROOT + "/")
  basename = File.basename(file)

  if %w[index.md log.md].include?(basename)
    if basename == "index.md" && file == File.join(ROOT, "index.md")
      match = content.match(/\A---\s*\n(.*?)\n---\s*\n/m)
      metadata = match && YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: false)
      errors << "index.md: root index must declare okf_version 0.2" unless metadata && metadata["okf_version"] == "0.2"
    elsif content.start_with?("---\n")
      errors << "#{relative}: reserved nested files must not contain front matter"
    end
  else
    match = content.match(/\A---\s*\n(.*?)\n---\s*\n/m)
    unless match
      errors << "#{relative}: missing OKF YAML front matter"
      next
    end

    begin
      metadata = YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: false)
      errors << "#{relative}: missing non-empty OKF type" unless metadata["type"].is_a?(String) && !metadata["type"].strip.empty?
      errors << "#{relative}: missing OKF description" unless metadata["description"].is_a?(String) && !metadata["description"].strip.empty?

      if metadata.key?("status") && !%w[draft stable deprecated].include?(metadata["status"])
        errors << "#{relative}: invalid OKF lifecycle status #{metadata['status']}"
      end

      if metadata.key?("stale_after") && !valid_date.call(metadata["stale_after"])
        errors << "#{relative}: stale_after must be an ISO 8601 date"
      end

      generated = metadata["generated"]
      unless generated.is_a?(Hash)
        errors << "#{relative}: missing generated provenance"
        generated = {}
      end

      generated_by = generated["by"]
      if !generated_by.is_a?(String) || !generated_by.match?(actor_pattern)
        errors << "#{relative}: generated.by does not follow the OKF actor convention"
      end

      generated_at = generated["at"]
      if generated_at && !valid_datetime.call(generated_at)
        errors << "#{relative}: generated.at must be an ISO 8601 datetime"
      end

      verification_events = metadata["verified"].is_a?(Hash) ? [metadata["verified"]] : metadata["verified"]
      if metadata.key?("verified") && (!verification_events.is_a?(Array) || verification_events.empty?)
        errors << "#{relative}: verified must be a mapping or non-empty list"
      end
      Array(verification_events).each do |event|
        unless event.is_a?(Hash) && event["by"].is_a?(String) && event["by"].match?(actor_pattern)
          errors << "#{relative}: verified.by does not follow the OKF actor convention"
        end
        unless event.is_a?(Hash) && valid_datetime.call(event["at"])
          errors << "#{relative}: verified.at must be an ISO 8601 datetime"
        end
      end

      source_ids = []
      Array(metadata["sources"]).each do |source|
        errors << "#{relative}: every OKF source needs a resource" unless source.is_a?(Hash) && source["resource"].to_s.length.positive?
        source_ids << source["id"] if source.is_a?(Hash) && source["id"]
      end
      errors << "#{relative}: source IDs must be unique" unless source_ids.uniq.length == source_ids.length
    rescue Psych::Exception => e
      errors << "#{relative}: invalid YAML front matter (#{e.message.lines.first.strip})"
    end
  end

  content.scan(/\[[^\]]+\]\(([^)]+)\)/).flatten.each do |raw_target|
    target = raw_target.strip.sub(/\A<|>\z/, "").split(/[?#]/, 2).first
    next if target.empty? || target.start_with?("#") || target.match?(%r{\A[a-z][a-z0-9+.-]*:}i)

    resolved = target.start_with?("/") ? File.join(ROOT, target.delete_prefix("/")) : File.expand_path(target, File.dirname(file))
    resolved = File.join(resolved, "index.md") if target.end_with?("/")
    errors << "Broken Markdown link in #{relative}: #{raw_target}" unless File.file?(resolved)
  end
end

# Directory indexes are intentionally simple, but they must not become stale.
Dir.glob(File.join(ROOT, "**", "index.md")).each do |index_file|
  next if index_file == File.join(ROOT, "index.md")

  directory = File.dirname(index_file)
  expected = Dir.glob(File.join(directory, "*.md"))
    .reject { |path| %w[index.md log.md].include?(File.basename(path)) }
    .map { |path| File.basename(path) }
    .sort
  linked = File.read(index_file)
    .scan(/\[[^\]]+\]\(([^)]+\.md)\)/)
    .flatten
    .reject { |target| target.match?(%r{\Ahttps?://}) }
    .map { |target| File.basename(target) }
    .sort

  missing = expected - linked
  extra = linked - expected
  relative = index_file.delete_prefix(ROOT + "/")
  errors << "#{relative}: missing entries for #{missing.join(', ')}" unless missing.empty?
  errors << "#{relative}: unexpected entries for #{extra.join(', ')}" unless extra.empty?
end

# The root index is the bundle's discovery boundary. It must expose every root
# concept and every indexed top-level area, even though it may also link deeper.
root_index = File.join(ROOT, "index.md")
root_targets = File.read(root_index)
  .scan(/\[[^\]]+\]\(([^)]+)\)/)
  .flatten
  .map { |target| target.split(/[?#]/, 2).first }
expected_root_targets = Dir.glob(File.join(ROOT, "*.md"))
  .reject { |path| %w[index.md log.md].include?(File.basename(path)) }
  .map { |path| File.basename(path) }
expected_root_targets.concat(
  Dir.glob(File.join(ROOT, "*", "index.md"))
    .map { |path| "#{File.basename(File.dirname(path))}/" }
)
missing_root_targets = expected_root_targets.uniq.sort - root_targets
errors << "index.md: missing root entries for #{missing_root_targets.join(', ')}" unless missing_root_targets.empty?

if errors.empty?
  puts "OKF v0.2 bundle valid: #{markdown_files.length} Markdown files"
  puts "Raintree catalog valid: #{entries.length} governed documents"
  exit 0
end

warn errors.join("\n")
exit 1
