# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rack_session_manipulation/version'

Gem::Specification.new do |spec|
  spec.name     = 'rack_session_manipulation'
  spec.version  = RackSessionManipulation::VERSION
  spec.authors  = ['Sam Stelfox']
  spec.email    = ['sstelfox@bedroomprogrammers.net']
  spec.files    = `git ls-files -z`.split("\x0").reject { |f| f =~ /^spec\// }

  spec.summary     = 'A rack middleware for exposing session state to tests.'
  spec.description = 'A rack middleware for exposing session state to tests.'
  spec.homepage    = 'https://github.com/sstelfox/rack_session_manipulation'
  spec.license     = 'MIT'

  spec.require_paths = ['lib']

  spec.add_dependency 'rack'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'capybara'

  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'simplecov'

  spec.add_development_dependency 'rdoc'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'yard'

  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
end
