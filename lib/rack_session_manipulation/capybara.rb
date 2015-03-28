# Parent module for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # Capybara helpers for accessing and setting session values
  module Capybara
    def session=(hash)
      data = RackSessionManipulation.encode(hash)
      page.driver.put(RackSessionManipulation.config.path, session_data: data)
    end

    def session
      page.driver.get(RackSessionManipulation.config.path)
      data = page.driver.last_response.body
      RackSessionManipulation.decode(data)
    end
  end
end
