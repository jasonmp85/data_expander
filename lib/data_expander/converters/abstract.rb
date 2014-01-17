module DataExpander
  module Converters
    class Abstract
      def initialize(**options)
      end

      def convert(val)
        fail 'subclasses must implement this method'
      end
    end
  end
end
