require 'csv'

module DataExpander
  # This class encapsulates reading CSV input and converting string fields
  # to typed representations based on an positional array of converters.
  class Reader
    include Enumerable

    def initialize(input, skip_headers: true, converters:)
      @csv = CSV.new(input, skip_blanks: true)
      @csv.readline if skip_headers

      @converters = converters
    end

    def each(&block)
      @csv.each do |row|
        begin
          block.call(convert!(row))
        rescue ArgumentError => ae
          warn "WARN: #{ae.message}"
          warn "SKIPPED: #{row.inspect}"

          next
        end
      end

      self
    end

    private

    def convert!(row)
      row.zip(@converters).each_with_index do |(val, conv), i|
        row[i] = conv.convert(val)
      end

      row
    end
  end
end
