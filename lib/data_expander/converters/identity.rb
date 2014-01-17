require 'data_expander/converters/abstract'

module DataExpander
  module Converters
    # The simplest possible converter: just returns its input.
    class Identity < Abstract
      def convert(val)
        val
      end
    end
  end
end
