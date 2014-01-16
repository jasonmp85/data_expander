module DataExpander
  module Generators
    class Uniform
      def initialize(type: :float)
        unless %i[float integer time].include? type
          fail ArgumentError, 'unsupported type'
        end
        
        @start = @end = nil
        @type  = type
      end

      def observe(value)
        @start = value if @start.nil? or value < @start
        @end   = value if @end.nil?   or value > @end
      end

      def generate
        if @start and @end
          Kernel.rand(@start...@end)
        else
          Generators.f_to_type(0, @type)
        end
      end
    end
  end
end
