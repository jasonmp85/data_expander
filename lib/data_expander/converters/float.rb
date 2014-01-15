module DataExpander
  module Converters
    # Converts strings looking like floating-point into actual floats. Anything
    # parsed as a float literal by Ruby (including unary plus signs, exponents,
    # and leading zeros) is accepted and converted by this converter.
    #
    # Note that "NaN" and "Infinity" are _not_ valid float literals in Ruby. It
    # models them as constants on the Float class instead. Thus there is no way
    # to ingest NaN or infinite values from input; however, the sign of zeros
    # _is_ correctly preserved, so "-0.0" is converted correctly.
    class Float
      def call(val)
        Float(val)
      end
    end
  end
end
