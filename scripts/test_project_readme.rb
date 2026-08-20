# frozen_string_literal: true

root = File.expand_path("..", __dir__)
readme = File.read(File.join(root, "README.md"))

required = [
  "<!-- project-record: raintree-standards -->",
  "**Pre-1.0 open-source standards library",
  "## Start with a task",
  "## Lifecycle and trust boundary",
  "## Raintree open-source system",
  "## Project policies"
]

missing = required.reject { |value| readme.include?(value) }
abort("README.md missing required project sections: #{missing.join(', ')}") unless missing.empty?
abort("README.md must contain exactly one H1") unless readme.lines.count { |line| line.start_with?("# ") } == 1
abort("README.md must not contain concept frontmatter") if readme.start_with?("---\n")

puts "project README checks passed"
