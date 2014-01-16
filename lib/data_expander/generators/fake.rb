require 'ffaker'
require 'forwardable'

module DataExpander
  module Generators
    class Fake
      def initialize(type: :string, mod: 'Name', method: 'name')
        fail ArgumentError, 'unsupported type' unless type == :string

        target = Faker.const_get(mod)

        extend SingleForwardable
        def_delegator(target, method, :generate)
      end

      def observe(value)
        # no-op
      end
    end
  end
end
