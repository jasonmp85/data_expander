require 'spec_helper'

describe DataExpander::Converters do
  subject { described_class }

  describe '::IDENTITY' do
    subject { super()::IDENTITY }

    it { should respond_to(:call).with(1).argument }
  end
end
