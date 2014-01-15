# Needs a converter as its subject.
# Usage: it { should convert("2").to(2) }
RSpec::Matchers.define :convert do |input|
  match do |converter|
    @actual = converter.call(input)
    @actual.eql? @expected
  end

  chain(:to) { |expected| @expected = expected }

  description do
    "convert #{input.inspect} to #{desc(@expected)}"
  end

  failure_message_for_should do |actual|
    "expected #{input.inspect} to be converted to #{desc(@expected)}"
  end

  failure_message_for_should_not do |actual|
    "expected #{input.inspect} not to be converted to #{desc(@expected)}"
  end

  def desc(val)
    type = val.class.to_s.downcase
    "the #{type} #{val.inspect}"
  end
end

# Needs a converter as its subject.
# Usage: it { should fail_to_convert('123') }
RSpec::Matchers.define :fail_to_convert do |input|
  match do |converter|
    begin
      converter.call(input)
      false
    rescue StandardError => @exception
      true
    end
  end

  failure_message_for_should do |actual|
    "expected a failure when converting #{input.inspect}"
  end

  failure_message_for_should_not do |actual|
    "expected no failures when converting #{input.inspect}, but " +
    "#{@exception.inspect} was raised"
  end
end
