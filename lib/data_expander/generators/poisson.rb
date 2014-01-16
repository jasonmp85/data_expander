module DataExpander
  module Generators
    class Poisson
      def initialize(type: :time)
        unless %i[float time].include? type
          fail ArgumentError, 'unsupported type'
        end

        @current = nil
        @sorter  = IO.popen({'LC_ALL' => 'C'}, %w[sort -n -], 'r+')
        @type    = type
      end

      def observe(value)
        @current = value if @current.nil? or value > @current
        @sorter.puts(value.to_f)
      end

      def generate
        @current ||= Generators.f_to_type(0, @type)
        puts lambda
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
        u = rand() while u.zero? # Choose random in range (0, 1]
        - Math.log(rand(u)) / lambda
      end

      # See comment on #delta for more info.
      def lambda
        @lambda ||= begin
          @sorter.close_write

          @sorter.each_cons(2).reduce([0.0, 0.0]) do |memo, (prev, curr)|
            puts prev, curr, "<br/>"
            memo[0] += (curr.to_f - prev.to_f)
            memo[1] += 1
            memo
          end
            .reduce { |n,d| if d.zero? then 1 else (n / d) end }
            .tap { @sorter.close() }
        end
      end
    end
  end
end
