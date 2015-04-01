# Parent namespace for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # Various utility methods that will be module level functions for the parent
  # namespace module.
  module Utilities
    # Helper method for decoding the session state into a standard Ruby hash.
    # This data is exposed as JSON, and is parsed as such.
    #
    # @param [String] encoded_data JSON encoded session data
    # @return [Hash] Hash version of the session data
    def decode(encoded_data)
      JSON.parse(encoded_data)
    end

    # Helper method for encoding modified session state for the middleware. The
    # middleware expects JSON so this is just a thin wrapper for encoding to
    # JSON.
    #
    # @param [Hash] obj An object that can be serialized using JSON, generally
    #   this is a hash.
    # @return [String] The encoded data.
    def encode(obj)
      JSON.generate(obj)
    end

    # SecureRandom raises a NotImplementedError if no random device is
    # available in that case fallback on Kernel.rand. Shamelessly stolen from
    # the Sinatra session secret generation code.
    #
    # @return [String]
    def random_path_prefix
      num = begin
        require 'securerandom'
        SecureRandom.random_number(2**128 - 1)
      rescue LoadError, NotImplementedError
        Kernel.rand(2**128 - 1)
      end
      format('/%032x', num)
    end
  end
end
