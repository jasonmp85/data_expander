module DataExpander
  module Generators
    # An abstract base class to contain any shared functionality. Ensures all
    # generators check for a type and expose it via a reader.
    class Abstract
      attr_reader :type

      def initialize(type:, **options)
        @type = type
      end
    end
  end
end
