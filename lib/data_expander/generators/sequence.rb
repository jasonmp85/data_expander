require 'data_expander/generators/abstract'

module DataExpander
  module Generators
    # Assumes incoming data represents an increasing sequence of integers, such
    # as the primary key column of a database table. Finds the maximum observed
    # value, then generates new increasing integers starting from there.
    class Sequence < Abstract
      def initialize(type: :integer, observed: nil)
        fail ArgumentError, 'unsupported type' unless type == :integer

        @current  = nil
        @observed = observed

        super
      end

      def observe(value)
        @current = value if @current.nil? || (value > @current)
        @observed.add(@current) unless @observed.nil?
      end

      def generate
        generated = (@current || 0) + 1
        observe(generated)

        generated
      end
    end
  end
end
