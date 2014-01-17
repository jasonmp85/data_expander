require 'data_expander/generators/abstract'

module DataExpander
  module Generators
    # Assumes incoming data is normally distributed and calculates its observed
    # mean and standard deviation, which are used to produce a normal random
    # variate in order to generate new data.
    #
    # See http://en.wikipedia.org/w/index.php?oldid=587026428#Online_algorithm
    class Normal < Abstract
      def initialize(type: :float)
        unless %i[float integer time].include? type
          fail ArgumentError, 'unsupported type'
        end

        @n           = 0
        @mean        = 0.0
        @diff_sq_sum = 0.0

        super
      end

      def observe(value)
        value = value.to_f

        @std_dev = nil
        @n    += 1

        delta  = value - @mean
        @mean += delta / @n

        @diff_sq_sum += delta * (value - @mean)
      end

      def generate
        @nvar ||= Variable.new(@mean, std_dev)
        fvalue = @nvar.rand
        Generators.f_to_type(fvalue, type)
      end

      private

      def std_dev
        @std_dev ||= Math.sqrt(@diff_sq_sum / (@n - 1))
      end

      # From http://stackoverflow.com/a/6178290
      class Variable
        def initialize(mean, std_dev)
          @mean = mean
          @std_dev = std_dev
          @valid = false
          @next = 0
        end

        def rand
          if @valid
            @valid = false
            return @next
          else
            @valid = true
            x, y = self.class.gaussian(@mean, @std_dev)
            @next = y
            return x
          end
        end

        private

        def self.gaussian(mean, std_dev)
          theta = 2 * Math::PI * (1 - Kernel.rand)
          rho = Math.sqrt(-2 * Math.log(1 - Kernel.rand))
          scale = std_dev * rho
          x = mean + scale * Math.cos(theta)
          y = mean + scale * Math.sin(theta)

          [x, y]
        end
      end

      private_constant :Variable
    end
  end
end
