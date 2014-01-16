require 'data_expander/generators/fake'
require 'data_expander/generators/normal'
require 'data_expander/generators/poisson'
require 'data_expander/generators/sequence'
require 'data_expander/generators/uniform'

module DataExpander
  module Generators
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
