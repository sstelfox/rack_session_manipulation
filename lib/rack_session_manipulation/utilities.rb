module RackSessionManipulation
  module Utilities
    # SecureRandom raises a NotImplementedError if no random device is
    # available in that case fallback on Kernel.rand. Shamelessly stolen from
    # the Sinatra session secret generation code.
    #
    # @return [String]
    def random_path_prefix
      begin
        require 'securerandom'
        SecureRandom.hex(16)
      rescue LoadError, NotImplementedError
        "%016x" % Kernel.rand(2**64-1)
      end
    end
  end
end
