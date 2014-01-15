module DataExpander
  # This module contains simple classes to convert an incoming string value to
  # a typed representation. Converters should fail-fast if such a conversion is
  # impossible. The contract of a converter is simple: it implements a method
  # named `call` which accepts a string value and returns the converted value.
  module Converters
    # The simplest converter: simply returns its input.
    IDENTITY = ->(val) { val }.freeze
  end
end
