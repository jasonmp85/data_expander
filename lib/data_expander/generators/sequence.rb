module DataExpander
  module Generators
    class Sequence
      def initialize(type: :integer, observed: nil)
        fail ArgumentError, 'unsupported type' unless type == :integer

        @current  = nil
        @observed = observed
      end

      def observe(value)
        @current = value if @current.nil? or value > @current
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
