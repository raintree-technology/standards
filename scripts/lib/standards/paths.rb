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
    # Both sides are resolved through their symlinks before comparison, so a
    # symlink inside the bundle pointing outside it is correctly rejected.
    # Resolving the root as well is what keeps checkouts reached through a
    # symlinked parent working -- on macOS /tmp is itself a link to
    # /private/tmp, and resolving only one side would reject every path.
    #
    # Resolution stops at the deepest existing ancestor, because callers ask
    # about paths that do not exist yet (a catalog entry naming a missing file,
    # a broken Markdown link). Those keep their unresolved tail, which cannot
    # contain a symlink precisely because it does not exist.
    def self.contained?(root, candidate)
      base = real_path(root)
      expanded = real_path(candidate)
      expanded == base || expanded.start_with?(base + File::SEPARATOR)
    end

    # File.realpath for the part of +path+ that exists, with the rest appended.
    def self.real_path(path)
      expanded = File.expand_path(path)
      existing = expanded
      tail = []

      until File.exist?(existing)
        parent = File.dirname(existing)
        break if parent == existing # reached the filesystem root

        tail.unshift(File.basename(existing))
        existing = parent
      end

      resolved = File.realpath(existing)
      tail.empty? ? resolved : File.join(resolved, *tail)
    rescue SystemCallError
      # An unreadable or looping symlink cannot be shown to be inside the
      # bundle, so fall back to the textual form and let the caller reject it.
      File.expand_path(path)
    end

    # Path of +absolute+ as written in validator messages: relative to the
    # bundle root, or the untouched absolute path when it lies outside.
    #
    # Resolves the same way contained? does, so the prefix it strips is the one
    # contained? matched on.
    def self.relative(root, absolute)
      return File.expand_path(absolute) unless contained?(root, absolute)

      base = real_path(root)
      expanded = real_path(absolute)
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
