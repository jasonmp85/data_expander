require 'spec_helper'

describe DataExpander::Reader do
  # Some fake CSV input
  let(:csv_data) { "foo,bar,baz\n1,2,3\n4,5,6\n" }

  let(:input) { StringIO.new(csv_data, 'r') }

  # Convert to integer
  let(:converters) { [DataExpander::Converters::Integer.new] * 3 }
  let(:opts) { { converters: converters } }

  subject { described_class.new(input, opts) }

  its(:entries) { should eq [[1, 2, 3], [4, 5, 6]] }
  it { should be_kind_of(Enumerable) }

  context 'when instantiated with skip_headers set to false' do
    let(:csv_data) { "1,2,3\n4,5,6" }
    let(:opts) { { converters: converters, skip_headers: false } }

    its(:entries) { should eq [[1, 2, 3], [4, 5, 6]] }
  end

  context 'when provided bad data' do
    let(:csv_data) { "foo,bar,baz\n1,2,3\nbad,worse,worst\n" }

    it('should skip the bad lines and print a warning') do
      Kernel.should_receive(:warn).at_least(:once)

      subject.entries.should eq [[1, 2, 3]]
    end
  end
end
