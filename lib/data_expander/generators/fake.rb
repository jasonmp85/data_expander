require 'ffaker'
require 'forwardable'

module DataExpander
  module Generators
    # This generator produces fake data using the ffaker gem. Its observations
    # do not affect output at all: it's basically a wrapper around a call to a
    # particular ffaker method. Produces strings only.
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