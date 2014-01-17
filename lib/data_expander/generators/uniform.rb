require 'data_expander/generators/abstract'

module DataExpander
  module Generators
    # Finds the observed range of data and uniformly generates new values from
    # within that range.
    class Uniform < Abstract
      def initialize(type: :float)
        unless %i[float integer time].include? type
          fail ArgumentError, 'unsupported type'
        end

        @start = @end = nil

        super
      end

      def observe(value)
        @start = value if @start.nil? || (value < @start)
        @end   = value if @end.nil?   || (value > @end)
      end

      def generate
        if @start && @end
          Kernel.rand(@start...@end)
        else
          Generators.f_to_type(0, type)
        end
      end
    end
  end
end
