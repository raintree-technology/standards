# frozen_string_literal: true

module Standards
  # Path handling for a validator rooted at a single bundle directory.
  #
  # Two problems this exists to solve:
  #
  # 1. Dir.glob treats its pattern as a pattern all the way down, so a checkout
  #    under a directory containing "[", "{", "*" or "?" silently matched
  #    nothing and the bundle validated as empty while still exiting 0. Globs
  #    here always pass the root through `base:`, which is taken literally.
  # 2. Nothing confirmed that a resolved path stayed inside the bundle, so a
  #    catalog entry or Markdown link could point at a file outside the
  #    repository and be accepted as long as it existed on the host.
  module Paths
    # Expands +relative+ against +root+ without letting the result escape it.
    # Returns nil when the result would land outside the bundle.
    def self.resolve(root, relative)
      candidate = File.expand_path(File.join(root, relative.to_s))
      contained?(root, candidate) ? candidate : nil
    end

    # True when +candidate+ is +root+ itself or sits beneath it.
    #
    # Compares expanded paths textually and does not resolve symlinks: a symlink
    # inside the bundle that points outside it is treated as inside. That keeps
    # the check predictable on checkouts reached through symlinked parents,
    # which is the common case on macOS (/tmp -> /private/tmp).
    def self.contained?(root, candidate)
      base = File.expand_path(root)
      expanded = File.expand_path(candidate)
      expanded == base || expanded.start_with?(base + File::SEPARATOR)
    end

    # Path of +absolute+ as written in validator messages: relative to the
    # bundle root, or the untouched absolute path when it lies outside.
    def self.relative(root, absolute)
      base = File.expand_path(root)
      expanded = File.expand_path(absolute)
      return expanded unless contained?(base, expanded)

      expanded == base ? "." : expanded.delete_prefix(base + File::SEPARATOR)
    end

    # Sorted, root-relative glob results.
    #
    # +pattern+ is relative to +root+ and is the only part treated as a pattern.
    # Sorting makes message order independent of filesystem enumeration order,
    # which differs between APFS and ext4.
    def self.glob(root, pattern)
      Dir.glob(pattern, base: root).sort
    end

    # Sorted absolute paths for +pattern+ under +root+.
    def self.glob_absolute(root, pattern)
      glob(root, pattern).map { |entry| File.join(root, entry) }
    end
  end
end
