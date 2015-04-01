module RackSessionManipulation
  # This module exposes the session state helpers to Capybara, allowing feature
  # tests to quickly access the session mechanisms.
  module Capybara
    def reset_session
      driver.delete(RackSessionManipulation.config.path)
    end

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
