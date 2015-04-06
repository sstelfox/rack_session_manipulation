# Parent namespace for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # This module exposes the session state helpers to Capybara, allowing feature
  # tests to quickly access the session mechanisms.
  module Capybara
    # Provides a mechanism to completely reset the server's session to a fresh
    # blank slate.
    def reset_session
      driver_method_fallback(:delete, session_manipulation_config.path, data)
    end

    # Retrieve a hash containing the entire state of the current session.
    #
    # @return [Hash] Hash of the session
    def session
      driver.get(session_manipulation_config.path)
      session_manipulation_config.encoder.decode(driver.response.body)
    end

    # Updates the state of the current session. An important thing to note
    # about this mechanism is that it does not set the session to perfectly
    # match the state of the provided hash. The provided hash is effectively
    # merged with the current state of the session.
    #
    # This also does not support marshalling objects into the session state.
    # This limitation is intentional as objects stored in sessions tend to be
    # a detriment to both performance and security.
    #
    # @param [Hash] hash Data to be set / updated within the current session.
    def session=(hash)
      data = {
        'session_data' => session_manipulation_config.encoder.encode(hash)
      }
      driver_method_fallback(:put, session_manipulation_config.path, data)
    end

    def session_manipulation_config
      @rsm_config ||= Config.new
    end

    protected

    # Capybara drivers are only required to implement the #get method. Where
    # appropriate we'll use the correct HTTP method, but when unavailable we'll
    # use the fallback mechanism.
    #
    # There may be a subtle bug in this fallback mechanism when the driver
    # doesn't support 'POST' requests. If large data payloads are used. Normal
    # HTTP request parameters within the URL itself are limited to 1024
    # characters.
    #
    # @param [Symbol] method A valid HTTP method name (all lowercase).
    # @param [String] path The path to request in the driver's rack app.
    # @param [Hash] dat An optional hash of data that will be sent along as
    #   part of the query parameters.
    def driver_method_fallback(method, path, dat = {})
      if driver.respond_to?(method)
        driver.send(method, path, dat)
        return
      end

      data.merge!('_method' => method.to_s.upcase)
      driver.respond_to?(:post) ? driver.post(path, dat) : driver.get(path, dat)
    end
  end
end

# When this file is required automatically expose it through the Capybara
# session helpers.
require 'capybara/session'
Capybara::Session.send(:include, RackSessionManipulation::Capybara)
