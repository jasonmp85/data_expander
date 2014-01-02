# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'data_expander/version'

Gem::Specification.new do |spec|
  spec.name          = 'data_expander'
  spec.version       = DataExpander::VERSION
  spec.authors       = ['Jason Petersen']
  spec.email         = ['jason@citusdata.com']
  spec.summary       = %q{Expand a CSV file based on existing rows}
  spec.description   = %q{Given an input CSV file, produces a CSV file that
                          is a superset of the input but with similar statistics.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.required_ruby_version     = '~> 2.1'
  spec.required_rubygems_version = '~> 2.2'

  spec.files       = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake',    '~> 10.1'
  spec.add_development_dependency 'rspec',   '~> 2.14'
  spec.add_development_dependency 'rubocop', '~> 0.16.0'
end
