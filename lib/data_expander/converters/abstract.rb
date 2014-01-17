module DataExpander
  module Converters
    # An abstract base class to contain any shared functionality. For now just
    # ensures a helpful exception gets thrown if a subclass doesn't implement
    # the `convert` method.
    class Abstract
      def initialize(**options)
      end

      def convert(val)
        fail 'subclasses must implement this method'
      end
    end
  end
end
