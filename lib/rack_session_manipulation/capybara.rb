# Parent module for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # Capybara helpers for accessing and setting session values
  module Capybara
    def session=(hash)
      data = { session_data: RackSessionManipulation.encode(hash) }

      page.driver.put(RackSessionManipulation.config.path, data)
      page.driver.status_code.should eql(204)
    end

    def session
      page.driver.get(RackSessionManipulation.config.path)
      page.driver.status_code.should eql(200)

      RackSessionManipulation.decode(page.driver.last_response.body)
    end
  end
end
