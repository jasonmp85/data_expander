require 'data_expander/converters/abstract'

module DataExpander
  module Converters
    class Identity < Abstract
      def convert(val)
        val
      end
    end
  end
end
