module DataExpander
  module Converters
    # Converts numeric-looking strings into actual integers. Some special
    # handling is required in order to reject strings with custom radices
    # (such as '0x123' or '0b010010') because accepting them would probably
    # be surprising to users. In addition, leading zeros are stripped, since
    # Kernel#Integer switches to octal when they are present.
    class Integer
      # Matches optional leading space and then all zeros up to (but not
      # including) a radix indicator or subsequent digit.
      LEADING_ZEROS = /\A\s*0+(?=[bdox\d])/i.freeze
      private_constant :LEADING_ZEROS

      def call(val)
        val.sub!(LEADING_ZEROS, '')

        Integer(val)
      end
    end
  end
end
