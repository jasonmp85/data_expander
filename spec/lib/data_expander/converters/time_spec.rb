require 'spec_helper'

describe DataExpander::Converters::Time do
  SECS_IN_HOUR = 3600.freeze

  let(:base)     { [2011, 10, 5, 22, 26, 12] }
  let(:frac)     { Time.gm(*base, 897_286) }
  let(:no_frac)  { Time.gm(*base) }
  let(:whole_tz) { Time.new(*base, +10 * SECS_IN_HOUR) }
  let(:half_tz)  { Time.new(*base, - SECS_IN_HOUR / 2) }
  let(:no_tz)    { Time.local(*base) }
  let(:long_ago) { Time.local(-10_000, *base[1..-1]) }

  it_should_behave_like 'a converter'

  context 'with no format specified' do
    it { should convert('2011-10-05T22:26:12.897286z').to(frac) }
    it { should convert('2011-10-05T22:26:12Z').to(no_frac) }
    it { should convert('2011-10-05T22:26:12+10:00').to(whole_tz) }
    it { should convert('2011-10-05T22:26:12-00:30').to(half_tz) }
    it { should convert('2011-10-05T22:26:12').to(no_tz) }
    it { should convert('-10000-10-05T22:26:12').to(long_ago) }

    it { should convert('   2011-10-05T22:26:12').to(no_tz) }
    it { should convert('2011-10-05T22:26:12   ').to(no_tz) }

    it { should fail_to_convert('tomorrow') }
    it { should fail_to_convert('2011-10-05') }
    it { should fail_to_convert('2011-10-05T22:26') }
    it { should fail_to_convert('2011-10-05T10:26 PM') }
    it { should fail_to_convert('2011-10-05 22:26:12') }
  end

  context 'with a custom format string' do
    let(:format) { '%Y-%m-%d %H:%M:%S' }
    subject { described_class.new(format) }

    it { should convert('2011-10-05 22:26:12').to(no_tz) }
    it { should convert('-10000-10-05 22:26:12').to(long_ago) }

    it { should fail_to_convert('tomorrow') }
    it { should fail_to_convert('2011-10-05') }
    it { should fail_to_convert('2011-10-05 22:26') }
    it { should fail_to_convert('2011-10-05 22:26-07:00') }
    it { should fail_to_convert('2011-10-05 10:26 PM') }
    it { should fail_to_convert('2011-10-05T22:26:12') }
  end
end
