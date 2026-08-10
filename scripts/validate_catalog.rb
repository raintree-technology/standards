#!/usr/bin/env ruby

require "date"
require "yaml"

ROOT = File.expand_path("..", __dir__)
CATALOG = File.join(ROOT, "catalog.yaml")
errors = []

catalog = YAML.safe_load(File.read(CATALOG), permitted_classes: [Date], aliases: false)
entries = %w[foundations standards profiles].flat_map { |key| catalog.fetch(key, []) }
ids = {}

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
  %w[id title type status owners last_reviewed applies_to tags].each do |field|
    errors << "#{entry['path']}: missing #{field}" unless metadata.key?(field)
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

  Array(metadata["depends_on"]).each do |dependency|
    # Checked after all documents have been indexed.
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
  content.scan(/\[[^\]]+\]\(([^)]+\.md)\)/).flatten.each do |target|
    next if target.match?(%r{\Ahttps?://})

    resolved = File.expand_path(target, File.dirname(file))
    errors << "Broken Markdown link in #{file.delete_prefix(ROOT + "/")}: #{target}" unless File.file?(resolved)
  end
end

if errors.empty?
  puts "Catalog valid: #{entries.length} governed documents, #{markdown_files.length} Markdown files"
  exit 0
end

warn errors.join("\n")
exit 1
