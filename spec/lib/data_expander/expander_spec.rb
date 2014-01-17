require 'spec_helper'

describe DataExpander::Expander do
  let(:reader)  { [['a'], ['b'], ['c']] }
  let(:column)  { double('column') }
  let(:columns) { [column] * reader.first.size }
  let(:factor)  { 2 }

  subject { described_class.new(reader, columns: columns) }

  it { should be_kind_of(Enumerable) }

  context 'mocking column return values' do
    let(:rows_made) { reader.size * (factor - 1) }

    before do
      column.should_receive(:observe).with('a')
      column.should_receive(:observe).with('b')
      column.should_receive(:observe).with('c')

      rows_made.times { |i| column.should_receive(:generate).and_return(i) }
    end

    its(:entries) { should eq reader + [[0], [1], [2]] }

    context 'with a custom factor of 3' do
      let(:factor) { 3 }
      subject { described_class.new(reader, columns: columns, factor: factor) }

      its(:entries) { should eq reader + [[0], [1], [2], [3], [4], [5]] }
    end

    context 'with a custom factor of 1' do
      let(:factor) { 1 }
      subject { described_class.new(reader, columns: columns, factor: factor) }

      its(:entries) { should eq reader }
    end
  end
end
