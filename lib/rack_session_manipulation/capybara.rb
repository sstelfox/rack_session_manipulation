# Parent module for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # Capybara helpers for accessing and setting session values
  module Capybara
    def session=(hash)
      data = { 'session_data' => RackSessionManipulation.encode(hash) }
      driver.put(RackSessionManipulation.config.path, data)
    end

    def session
      driver.get(RackSessionManipulation.config.path)
      RackSessionManipulation.decode(driver.response.body)
    end
  end
end

require 'capybara/session'
Capybara::Session.send(:include, RackSessionManipulation::Capybara)
