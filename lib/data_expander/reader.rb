require 'csv'

require 'data_expander/converters'

module DataExpander
  # This class encapsulates reading CSV input and converting string fields
  # to typed representations based on an positional array of converters.
  class Reader
    include Enumerable

    def initialize(input, converters: [], skip_headers: true)
      @csv = CSV.new(input, skip_blanks: true)
      @csv.readline if skip_headers

      @converters = converters
    end

    def each(&block)
      @csv.each do |row|
        row.each_with_index do |val, i|
          converter = @converters[i] || Converters::IDENTITY
          row[i]    = converter.call(val)
        end

        block.call(row)
      end
    end
  end
end
