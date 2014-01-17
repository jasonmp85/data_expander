require 'csv'

module DataExpander
  # A wrapper around a reader and schema which will present a seamless
  # interface to read all rows from the reader followed by a series of
  # generated rows. The total number of rows produced is controlled by the
  # `factor` parameter, which defaults to two. For example, an expander given
  # a `reader` with 1,000 rows using the default `factor` would expose 2,000
  # rows via its `#each` method.
  class Expander
    include Enumerable

    def initialize(reader, factor: 2, columns:)
      @reader = reader
      @factor = factor
      @columns = columns

      @rows_read = 0
    end

    def each(&block)
      # Iterate over original values
      @reader.each do |row|
        block.call(row)

        row.zip(@columns) { |val, col| col.observe(val) }

        @rows_read += 1
      end

      @rows_read.freeze

      # Generate new values
      @rows_read.upto(@rows_read * @factor - 1) do
        block.call(@columns.map(&:generate))
      end

      self
    end
  end
end
