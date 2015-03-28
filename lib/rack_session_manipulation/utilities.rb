# Parent module for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # Various utility methods that will be module level functions for the parent
  # namespace module.
  module Utilities
    def decode(encoded_data)
      JSON.parse(encoded_data)
    end

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
        SecureRandom.random_number(2**64 - 1)
      rescue LoadError, NotImplementedError
        Kernel.rand(2**64 - 1)
      end
      format('/%016x', num)
    end
  end
end
