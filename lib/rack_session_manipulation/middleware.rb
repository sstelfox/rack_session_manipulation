# Parent module for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # Rack middleware that handles the accessing and modification of session
  # state.
  class Middleware
    def call(env)
      request = Rack::Request.new(env)
      return send(action, request) if (action = get_action(request))
      @app.call(env)
    end

    def initialize(app, _options = {})
      @app = app
      @routes = {
        GET: :retrieve,
        PUT: :update
      }
    end

    protected

    def extract_method(request)
      return request.request_method unless request.request_method == 'POST'
      return request.params['_method'].upcase if request.params['_method']
      request.request_method
    end

    def get_action(request)
      return unless request.path == RackSessionManipulation.path
      @routes[extract_method(request)]
    end

    def headers(length)
      {
        'Content-Type'   => 'application/json',
        'Content-Length' => length
      }
    end

    def retrieve(request)
      content = RackSessionManipulation.encode(request.session)

      [200, headers(content.length), content]
    end

    def update(request)
      session_data = request.params['session_data']
      request.session = RackSessionManipulation.decode(session_data)

      [204, headers(0), '']
    end
  end
end
