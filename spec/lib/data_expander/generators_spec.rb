require 'spec_helper'

describe DataExpander::Generators do
  subject { described_class }

  describe '::SUPPORTED_TYPES' do
    subject { super()::SUPPORTED_TYPES }

    it { should be_instance_of(Hash) }
    it { should be_frozen }
    it { should_not be_empty }

    its('keys.first')   { should be_instance_of Symbol }
    its('values.first') { should be_instance_of Class }
  end

  describe '#f_to_type' do
    {
        float: [[0, 0.0], [1.1, 1.1]],
      integer: [[0.4, 0], [1.5, 2]],
       string: [[0.5, '0.5'], [1.0, '1.0']],
         time: [[0, Time.at(0)]]
    }.each do |type, examples|
      examples.each do |input, output|
        it "should map the float #{input} to the #{type} #{output.inspect}" do
          subject.f_to_type(input, type).should eql output
        end
      end
    end

    it('rejects unknown types') do
      expect { subject.f_to_type(0, type: :unknown) }
        .to raise_error(ArgumentError)
    end
  end
end
