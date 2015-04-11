$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'simplecov'
require 'coveralls'

require 'rack/test'
require 'capybara/rspec'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.add_filter '/spec/'
SimpleCov.add_filter do |source_file|
  source_file.lines.count < 3
end

SimpleCov.start

require 'rack_session_manipulation'
require 'rack_session_manipulation/capybara'
require 'apps/rack_app'

RSpec.configure do |config|
  config.include(Rack::Test::Methods, type: :rack)

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # I use 'invalid' partial doubles to test associated methods in individual
    # modules.
    # mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.warnings = false
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.profile_examples = 3
  config.order = :random

  Kernel.srand(config.seed)
end
