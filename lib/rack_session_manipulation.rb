require 'rack_session_manipulation/config'
require 'rack_session_manipulation/middleware'
require 'rack_session_manipulation/utilities'
require 'rack_session_manipulation/version'

module RackSessionManipulation
  extend RackSessionManipulation::Utilities

  def self.config
    @config ||= RackSessionManipulation::Config.new(random_path_prefix)
  end

  def self.configure
    yield(config)
  end
end
