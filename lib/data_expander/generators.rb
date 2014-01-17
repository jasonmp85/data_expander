require 'data_expander/generators/fake'
require 'data_expander/generators/normal'
require 'data_expander/generators/poisson'
require 'data_expander/generators/relation'
require 'data_expander/generators/sequence'
require 'data_expander/generators/uniform'

module DataExpander
  # This module contains classes capable of generating new data after observing
  # an incoming stream. This generation could be random and unrelated to the
  # stream whatsoever, based on a distribution with statistics derived from the
  # stream itself, or some other approach altogether.
  #
  # Generators must implement two methods: `observe(input)`, which is called
  # with every input value in the original file, and `generate`, which returns
  # new values. Generator initializers should take a hash with a `type` value
  # which is one of the keys from ::SUPPORTED_TYPES. This specifies the type
  # it is expected to ingest and produce.
  module Generators
    # Supported generator types and their corresponding Ruby types
    SUPPORTED_TYPES = {
      float:   Float,
      integer: Integer,
      string:  String,
      time:    Time
    }.freeze

    def self.f_to_type(f, type)
      case type
      when :float   then f.to_f
      when :integer then f.round
      when :string  then f.to_s
      when :time    then Time.at(f)
      else fail ArgumentError, 'unexpected type'
      end
    end
  end
end
