require 'data_expander/converters/float'
require 'data_expander/converters/identity'
require 'data_expander/converters/integer'
require 'data_expander/converters/time'

module DataExpander
  # This module contains simple classes to convert an incoming string value to
  # a typed representation. Converters should fail-fast if such a conversion is
  # impossible. The contract of a converter is simple: it implements a method
  # named `convert` which accepts a string value and returns a converted value.
  module Converters
  end
end
