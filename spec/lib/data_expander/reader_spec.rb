require 'spec_helper'

describe DataExpander::Reader do
  # Some fake CSV input
  let(:input) do
    StringIO.new(<<-CSV, 'r')
foo,bar,baz
1,2,3
4,5,6
    CSV
  end

  # Just passthrough everything
  let(:converters) do
    3.times.map { DataExpander::Converters::Identity.new }
  end
  let(:opts) { { converters: converters } }

  subject { described_class.new(input, opts) }

  its(:entries) { should eq [%w[1 2 3], %w[4 5 6]] }

  context 'when instantiated with skip_headers set to false' do
    let(:opts) { { converters: converters, skip_headers: false } }

    it('should return headers') do
      subject.first.should eq %w[foo bar baz]
    end
  end
end
