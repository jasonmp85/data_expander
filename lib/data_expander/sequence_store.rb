require 'dbm'

module DataExpander
  # Provides storage capable of growing past memory bounds and being persisted
  # across program runs. Rather than a complete collection API, only `add` and
  # `rand` are provided. Useful for keeping track of existing IDs and then
  # using that list to generate foreign keys in another set of data.
  class SequenceStore
    attr_reader :size

    def initialize(path)
      @dbm  = DBM.new(path)
      @size = @dbm.size

      ObjectSpace.define_finalizer(self, self.class.close_db(@dbm))
    end

    def add(element)
      @dbm[@size.to_s] = element.to_s
      @size += 1
    end

    def rand
      @dbm[Kernel.rand(@size).to_s] unless @size.zero?
    end

    def self.close_db(dbm)
      proc { |id| dbm.close unless dbm.closed? }
    end
  end
end
