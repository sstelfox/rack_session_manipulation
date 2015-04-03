# Parent namespace for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # The stock encoder for session data. Encodes and decodes everything to/from
  # JSON payloads.
  module JSONEncoder
    class << self
      # Decoder for session state into a standard Ruby hash using JSON.
      #
      # @param [String] encoded_data JSON encoded session data
      # @return [Hash] Hash version of the session data
      def decode(encoded_data)
        JSON.parse(encoded_data)
      end

      # Encoder for session state using JSON.
      #
      # @param [Hash] obj An object that can be serialized using JSON,
      #   generally this is a hash.
      # @return [String] The encoded data.
      def encode(obj)
        JSON.generate(obj)
      end
    end
  end
end
