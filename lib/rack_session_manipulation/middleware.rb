module RackSessionManipulation
  class Middleware
    def initialize(app, options = {})
      @app = app
      @key = options[:key] || 'rack.session'

      @routing = [
      ]
    end

    def call(env)
    end
  end
end
