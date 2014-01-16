$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'test_frameworks'
end

require 'data_expander'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
