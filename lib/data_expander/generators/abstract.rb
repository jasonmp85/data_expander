module DataExpander
  module Generators
    class Abstract
      attr_reader :type

      def initialize(type:, **options)
        @type = type
      end
    end
  end
end
