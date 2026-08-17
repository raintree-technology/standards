# frozen_string_literal: true

module Standards
  # An ordered, de-duplicated collection of validation messages.
  #
  # Order is first-seen insertion order rather than sort order: messages are
  # emitted in the sequence the validator checks things, which keeps related
  # failures together. Determinism comes from feeding the validators sorted
  # inputs (see Paths.glob), not from sorting the output.
  class Findings
    include Enumerable

    def initialize
      @messages = []
      @seen = {}
    end

    # Records a message. Repeated messages collapse to the first occurrence so
    # that a document reached by two different checks reports once.
    def add(message)
      text = message.to_s
      return self if @seen.key?(text)

      @seen[text] = true
      @messages << text
      self
    end
    alias << add

    # Records +message+ only when +condition+ is falsy. Reads closer to the rule
    # being expressed than a trailing `unless` on a long line.
    def add_unless(condition, message)
      add(message) unless condition
      self
    end

    def each(&block)
      @messages.each(&block)
      self
    end

    def empty?
      @messages.empty?
    end

    def length
      @messages.length
    end
    alias size length

    def to_a
      @messages.dup
    end

    # Writes every message to +io+, one per line. Writes nothing at all when
    # empty, so a caller with no findings never emits a stray blank line.
    def report(io = $stderr)
      return if empty?

      io.puts(@messages)
    end
  end
end
