require 'spec_helper'

describe DataExpander::Reader do
  let(:input) do
    StringIO.new(<<-CSV, 'r')
foo,bar,baz
1,2,3
4,5,6
    CSV
  end

  context 'when instantiated with only an input' do
    subject { described_class.new(input) }

    it { should be_kind_of(Enumerable) }

    specify('should yield string arrays to a block passed to #each') do
      expect { |b| subject.each(&b) }
        .to yield_successive_args(%w[1 2 3], %w[4 5 6])
    end

    it('should skip headers') do
      subject.should_not include(%w[foo bar baz])
    end
  end

  context 'when instantiated with skip_headers set to false' do
    subject { described_class.new(input, skip_headers: false) }

    it('should return headers') do
      subject.first.should eq %w[foo bar baz]
    end
  end

  context 'when provided with a custom converter' do
    let(:converters) { [nil, ->(val) { val.to_i }, nil] }

    subject { described_class.new(input, converters: converters) }

    its(:entries) { should eq [['1', 2, '3'], ['4', 5, '6']] }
  end
end
