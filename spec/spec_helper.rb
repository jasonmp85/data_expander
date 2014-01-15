$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'data_expander'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
