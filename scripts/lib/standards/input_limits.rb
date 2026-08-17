# frozen_string_literal: true

require "find"

require_relative "paths"

module Standards
  # Bounds repository-controlled validator input before any file is parsed.
  module InputLimits
    MAX_FILES = 2_048
    MAX_FILE_BYTES = 2 * 1024 * 1024
    MAX_TOTAL_BYTES = 32 * 1024 * 1024
    EXTENSIONS = %w[.md .yaml .yml .json].freeze

    def self.validate(root, findings, max_files: MAX_FILES, max_file_bytes: MAX_FILE_BYTES, max_total_bytes: MAX_TOTAL_BYTES)
      initial_findings = findings.length
      root = File.expand_path(root)
      files = 0
      total_bytes = 0
      catch(:input_limit_reached) do
        Find.find(root) do |path|
          relative = path == root ? "." : path.delete_prefix("#{root}#{File::SEPARATOR}")
          stat = File.lstat(path)
          if stat.directory?
            Find.prune if relative == ".git"
            next
          end
          next unless stat.file? || stat.symlink?
          next unless EXTENSIONS.include?(File.extname(path))

          files += 1
          if files > max_files
            findings.add("validator input has more than #{max_files} files; limit is #{max_files}")
            throw :input_limit_reached
          end

          resolved = Paths.resolve(root, relative)
          if resolved.nil?
            findings.add("#{relative}: input path escapes the bundle root")
            next
          end

          bytes = File.size(resolved)
          if bytes > max_file_bytes
            findings.add("#{relative}: input is #{bytes} bytes; per-file limit is #{max_file_bytes} bytes")
            throw :input_limit_reached
          end

          total_bytes += bytes
          if total_bytes > max_total_bytes
            findings.add("validator input is more than #{max_total_bytes} bytes; total limit is #{max_total_bytes} bytes")
            throw :input_limit_reached
          end
        rescue SystemCallError => e
          findings.add("#{relative}: input cannot be inspected (#{e.message})")
        end
      end

      findings.length == initial_findings
    rescue SystemCallError => e
      findings.add("validator input root cannot be inspected (#{e.message})")
      false
    end
  end
end
