# Parent module for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # Rack middleware that handles the accessing and modification of session
  # state.
  class Middleware
    def initialize(app, options = {})
      @app = app
      @key = options[:key] || 'rack.session'

      @routing = [
      ]
    end

    def call(env)
      env
    end
  end
end
