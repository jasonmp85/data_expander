require 'spec_helper'

describe DataExpander do
  describe '::VERSION' do
    # See https://github.com/mojombo/semver.org/issues/59
    SEMVER_REGEX = /\A           # Anchor to beginning
        \d+\.\d+\.\d+            # Normal version number
        (?:-[\dA-Za-z\-]+        # Prerelease version start
          (?:\.[\-]+)*)?         # Prerelease version remainder
        (?:\+[\dA-Za-z\-]+       # Build info start
          (?:\.[\dA-Za-z\-]+)*)? # Build info remainder
        \z/x.freeze              # Anchor to end

    subject { super()::VERSION }

    it { should_not be_nil }
    it('should be a valid semantic version') { should match SEMVER_REGEX }
  end
end
