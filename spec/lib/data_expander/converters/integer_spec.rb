require 'spec_helper'

describe DataExpander::Converters::Integer do
  it_should_behave_like 'a converter'

  it { should convert('0').to(0) }
  it { should convert('00').to(0) }
  it { should convert('0252').to(252) }
  it { should convert('1').to(1) }
  it { should convert('-2').to(-2) }
  it { should convert('+3').to(+3) }
  it { should convert('1_000_000').to(1_000_000) }

  it { should fail_to_convert('0d170') }
  it { should fail_to_convert('0xaa') }
  it { should fail_to_convert('0b10101010') }
  it { should fail_to_convert('3.14') }
  it { should fail_to_convert('.02') }
  it { should fail_to_convert('1e10') }
  it { should fail_to_convert('10x performance') }
  it { should fail_to_convert('$5') }
  it { should fail_to_convert('1 2') }
  it { should fail_to_convert('--2') }
  it { should fail_to_convert('++3') }
end
