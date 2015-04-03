require 'json'

require 'rack_session_manipulation/config'
require 'rack_session_manipulation/json_encoder'
require 'rack_session_manipulation/middleware'
require 'rack_session_manipulation/utilities'
require 'rack_session_manipulation/version'

# RackSessionManipulation is rack middleware designed to expose internal
# session information to be read and modified from within tests.
module RackSessionManipulation
  extend RackSessionManipulation::Utilities

  # Keeps a globally accessible instance of a configuration object. This will
  # initialize a new Config object the first time this is called (using a
  # random path for the session access path).
  #
  # @return [RackSessionManipulation::Config]
  def self.config
    @config ||= RackSessionManipulation::Config.new(random_path_prefix, RackSessionManipulation::JSONEncoder)
  end

  # Allows block DSL style configuration of the global configuration instance.
  #
  # @yield [RackSessionManipulation::Config]
  def self.configure
    yield(config)
  end
end
