require 'dbm'

module DataExpander
  # Provides storage capable of growing past memory bounds and being persisted
  # across program runs. Rather than a complete collection API, only `add` and
  # `rand` are provided. Useful for keeping track of existing IDs and then
  # using that list to generate foreign keys in another set of data.
  class SequenceStore
    LINE_LENGTH = 499.freeze
    BLANK_LINE  = Array.new(LINE_LENGTH) { 0 }.freeze
    CONVERSION  = 'L*'.freeze

    attr_reader :size

    def initialize(path)
      @dbm  = DBM.new(path)

      size = @dbm['size'].to_i
      data = @dbm[pack(size / LINE_LENGTH)]

      @line_ref = [data].compact.map { |d| d.unpack(CONVERSION) }
      @size_ref = [size]

      ObjectSpace.define_finalizer(
        self, self.class.close_db(@dbm, @line_ref, @size_ref))
    end

    def size
      @size_ref.first
    end

    def add(element)
      flush
      @line_ref.first[size % LINE_LENGTH] = element
      @size_ref[0] += 1
    end

    def rand
      get(Kernel.rand(size))
    end

    def get(idx)
      ary_idx  = idx % LINE_LENGTH

      line_for_idx(idx)[ary_idx]
    end

    def flush
      if (size % LINE_LENGTH).zero?
        self.class.append(@dbm, @line_ref.first, size)

        @line_ref[0] = BLANK_LINE.dup
      end
    end

    def pack(val)
      self.class.pack(val)
    end

    private

    def line_for_idx(idx)
      return [] if size.zero?

      line_idx = idx / LINE_LENGTH

      if line_idx == (size / LINE_LENGTH)
        @line_ref.first
      else
        key  = pack(line_idx)
        data = @dbm[key]
        data.unpack(CONVERSION)
      end
    end

    def self.append(dbm, line, size)
      key  = (size - 1) / LINE_LENGTH
      dbm[pack(key)] = pack(line) unless line.nil?
    end

    def self.pack(val)
      Array(val).pack(CONVERSION)
    end

    def self.close_db(dbm, line_ref, size_ref)
      proc do |id|
        unless dbm.closed?
          append(dbm, line_ref.first, size_ref.first)
          dbm['size'] = size_ref.first.to_s

          dbm.close
        end
      end
    end
  end
end
