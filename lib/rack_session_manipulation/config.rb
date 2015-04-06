require 'rack_session_manipulation/json_encoder'

# Parent namespace for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # Various default configuration options for the middleware.
  DEFAULT_OPTIONS = {
    encoder: RackSessionManipulation::JSONEncoder,
    path:   '/rsm_session_path'
  }

  # A data storage structure for holding configuration related information.
  class Config
    attr_accessor :encoder, :path

    # Setup the configuration object with the provided options, falling back on
    # the configured defaults.
    #
    # @param [Hash<Symbol=>Object>] options Override the default configuration
    #   options with the provided parameters.
    def initialize(options = {})
      options = DEFAULT_OPTIONS.merge(options)

      self.encoder = options[:encoder]
      self.path = options[:path]
    end
  end
end
