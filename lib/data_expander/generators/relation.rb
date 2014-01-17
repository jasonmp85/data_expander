require 'data_expander/generators/abstract'

module DataExpander
  module Generators
    # Reuses observations from a previous scan of a sequence column of a table
    # in order to produce valid foreign keys in a new table.
    class Relation < Abstract
      def initialize(type: :integer, observed: nil)
        fail ArgumentError, 'unsupported type' unless type == :integer

        @observed = observed || Kernel

        super
      end

      def observe(value)
        # no-op
      end

      def generate
        @observed.rand.to_i
      end
    end
  end
end
