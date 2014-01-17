require 'forwardable'

module DataExpander
  # A class to tie together converters and generators into a coherent object
  # for a given database column. Not much here.
  class Column
    extend Forwardable

    def_delegator  :@converter, :convert
    def_delegators :@generator, :generate, :observe

    def initialize(generator: DataExpander::Generators::Fake.new, **options)
      conv_class = begin
        type = generator.type

        DataExpander::Converters.const_get(type.capitalize, false)
      rescue
        DataExpander::Converters::Identity
      end

      @converter = conv_class.new(options)
      @generator = generator
    end
  end
end
