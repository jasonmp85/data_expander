require 'spec_helper'

describe DataExpander::Converters::Identity do
  it_should_behave_like 'a converter'

  it { should convert('3').to('3') }
  it { should convert('jason').to('jason') }
end
