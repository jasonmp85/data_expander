require 'dbm'

module DataExpander
  # Provides a Set capable of growing beyond memory bounds and being persisted
  # across program runs. Rather than the whole Set API, only `add` and `rand`
  # are provided. Useful for keeping track of existing IDs and then using that
  # set to generate foreign keys in another set of data.
  class PersistentSet
    def initialize(path)
      @dbm  = DBM.new(path)

      ObjectSpace.define_finalizer(self, self.class.close_db(@dbm))
    end

    def add(element)
      value = element.to_s
      value_key = "v-#{value}"

      unless @dbm.key? value_key
        @dbm[size.to_s] = value
        @dbm[value_key] = ''
      end
    end

    def rand
      @dbm[Kernel.rand(size).to_s] unless size.zero?
    end

    def size
      @dbm.size / 2
    end

    def self.close_db(dbm)
      proc { |id| dbm.close unless dbm.closed? }
    end
  end
end
