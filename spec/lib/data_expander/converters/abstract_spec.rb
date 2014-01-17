require 'spec_helper'

describe DataExpander::Converters::Abstract do
  describe('#convert') do
    specify { expect { subject.convert('a') }.to raise_error(StandardError) }
  end
end
