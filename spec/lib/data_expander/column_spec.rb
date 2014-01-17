require 'spec_helper'

describe DataExpander::Column do
  context 'when provided no generator' do
    it 'should use a Generators::Fake instance' do
      DataExpander::Generators::Fake.any_instance
        .should_receive(:observe)
        .with(10)
      Faker::Name.should_receive(:name).and_return(:val)

      subject.observe(10)
      subject.generate.should eq :val
    end

    it 'should use the Identity converter' do
      DataExpander::Converters::Identity.any_instance.should_receive(:convert)

      subject.convert(10)
    end
  end

  context 'when provided a generator' do
    let(:generator) { double('generator') }
    let(:options)   { { key: 'value' } }

    subject { described_class.new(generator: generator, **options) }

    before { generator.stub(:type).and_return(:float) }

    it 'should request the right type of converter and pass on options' do
      DataExpander::Converters::Float
        .should_receive(:new)
        .with(options)
        .and_call_original

      subject.convert(10).should eql 10.0
    end

    it 'should use the provided generator' do
      generator.should_receive(:observe).with(10)
      generator.should_receive(:generate).and_return(:val)

      subject.observe(10)
      subject.generate.should eq :val
    end
  end
end
