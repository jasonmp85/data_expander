require 'spec_helper'

describe DataExpander::Converters::Float do
  it_should_behave_like 'a converter'

  it { should convert('0').to(0.0) }
  it { should convert('1').to(1.0) }
  it { should convert('01').to(1.0) }
  it { should convert('-2').to(-2.0) }
  it { should convert('+3').to(+3.0) }
  it { should convert('3.14').to(3.14) }
  it { should convert('.02').to(0.02) }
  it { should convert('1e10').to(1e10) }
  it { should convert(' 1').to(1.0) }
  it { should convert('1 ').to(1.0) }

  it { should fail_to_convert('10x performance') }
  it { should fail_to_convert('$5.00') }
  it { should fail_to_convert('1 2') }
  it { should fail_to_convert('1.2.3') }
  it { should fail_to_convert('--2') }
  it { should fail_to_convert('++3') }
  it { should fail_to_convert('3..14') }
  it { should fail_to_convert('1ee10') }
end
