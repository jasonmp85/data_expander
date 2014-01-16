require 'spec_helper'

describe DataExpander::Generators::Poisson do
  it_should_behave_like 'a generator of', :float, :time
end
