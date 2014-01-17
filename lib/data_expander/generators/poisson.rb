require 'data_expander/generators/abstract'

module DataExpander
  module Generators
    # Assumes incoming data represents a stream of independent, identically
    # distributed events occurring at a constant rate. This implies that the
    # distance between subsequent events follows a exponential distribution.
    # This generator calculates a maximum likelihood estimate for the rate
    # parameter of this exponential distribution in order to produce more
    # events with a similar frequency using the homogeneous Poisson process.
    #
    # See: http://en.wikipedia.org/w/index.php?oldid=590710226#Homogeneous
    class Poisson < Abstract
      def initialize(type: :time)
        unless %i[float time].include? type
          fail ArgumentError, 'unsupported type'
        end

        @current = nil
        @sorter  = IO.popen({ 'LC_ALL' => 'C' }, %w[sort -n -], 'r+')

        super
      end

      def observe(value)
        @current = value if @current.nil? || (value > @current)
        @sorter.puts(value.to_f)
      end

      def generate
        @current ||= Generators.f_to_type(0, type)
        @current += delta
      end

      private

      # See http://en.wikipedia.org/w/index.php?oldid=585382507 and pay special
      # attention to the section on estimating maximum likelihood (lambda) and
      # the section on generating variates of an exponential distribution. This
      # method returns samples from such a variate, to be used as increments in
      # a sequence.
      def delta
        u = 0.0
        u = Kernel.rand while u.zero? # Choose random in range (0, 1]
        - Math.log(u) / lambda
      end

      # See comment on `#delta` for more info.
      def lambda
        @lambda ||= begin
          @sorter.close_write

          s, c = *@sorter.each_cons(2).reduce([0, 0]) do |memo, (prev, curr)|
            memo[0] += (curr.to_f - prev.to_f)
            memo[1] += 1.0

            memo
          end

          @sorter.close

          c.zero? ? 1 : (c / s)
        end
      end
    end
  end
end
