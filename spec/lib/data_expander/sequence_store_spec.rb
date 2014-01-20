require 'spec_helper'
require 'tmpdir'

describe DataExpander::SequenceStore do
  subject { described_class.new('elements') }

  around do |example|
    Dir.mktmpdir(described_class.to_s.downcase) do |path|
      Dir.chdir(path, &example)
    end
  end

  before { ObjectSpace.should_receive(:define_finalizer).and_call_original }

  its(:size) { should be_zero }
  its(:rand) { should be_nil  }

  context 'after an element has been added' do
    let(:element) { 100 }
    before { subject.add(element) }

    its(:size) { should eq 1 }
    its(:rand) { should eq element }

    it 'should increase in size after a duplicate is added' do
      expect { subject.add(element) }.to change { subject.size }
    end
  end

  context 'after three elements have been added' do
    let(:numbers) { [1, 2, 3] }

    before { numbers.each { |e| subject.add(e) } }

    its(:size) { should eq 3 }
    it('should provide random access') { numbers.should include(subject.rand) }

    context 'and Kernel#rand has been stubbed' do
      before do
        Kernel.should_receive(:rand)
          .with(3)
          .exactly(3).times
          .and_return(0, 1, 2)
      end

      it 'should return results in order' do
        3.times.map { subject.rand }.should eq numbers
      end
    end
  end
end
