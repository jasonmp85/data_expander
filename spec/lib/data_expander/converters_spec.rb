require 'spec_helper'

describe DataExpander::Converters do
  subject { described_class }

  describe '::IDENTITY' do
    subject { super()::IDENTITY }

    it_should_behave_like 'a converter'

    it { should convert('3').to('3') }
    it { should convert('jason').to('jason') }
  end
end
