require 'ffaker'
require 'forwardable'

require 'data_expander/generators/abstract'

module DataExpander
  module Generators
    # This generator produces fake data using the ffaker gem. Its observations
    # do not affect output at all: it's basically a wrapper around a call to a
    # particular ffaker method. Produces strings only.
    class Fake < Abstract
      def initialize(type: :string, mod: 'Name', method: 'name')
        fail ArgumentError, 'unsupported type' unless type == :string

        target = Faker.const_get(mod, false)

        extend SingleForwardable
        def_delegator(target, method, :generate)

        super
      end

      def observe(value)
        # no-op
      end
    end
  end
end
