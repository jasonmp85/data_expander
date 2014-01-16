require 'spec_helper'

describe DataExpander::Generators::Uniform do
  it_should_behave_like 'a generator of', :float, :integer, :time
end
