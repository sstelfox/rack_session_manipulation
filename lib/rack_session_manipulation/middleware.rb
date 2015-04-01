# Parent module for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # Rack middleware that handles the accessing and modification of session
  # state.
  class Middleware
    def call(env)
      request = Rack::Request.new(env)

      action = get_action(request)
      action.nil? ? @app.call(env) : send(action, request)
    end

    def initialize(app, _options = {})
      @app = app
      @routes = {
        'DELETE'  => :reset,
        'GET'     => :retrieve,
        'PUT'     => :update
      }
    end

    protected

    def extract_method(request)
      return request.request_method unless request.request_method == 'POST'
      return request.params['_method'].upcase if request.params['_method']
      request.request_method
    end

    def get_action(request)
      return unless request.path == RackSessionManipulation.config.path
      @routes[extract_method(request)]
    end

    def headers(length)
      {
        'Content-Type'   => 'application/json',
        'Content-Length' => length
      }
    end

    def reset(request)
      request.env['rack.session'].destroy
      [204, headers(0), '']
    end

    def retrieve(request)
      session_hash = request.env['rack.session'].to_hash
      content = RackSessionManipulation.encode(session_hash)

      [200, headers(content.length), content]
    end

    def update(request)
      session_data = request.params['session_data']
      RackSessionManipulation.decode(session_data).each do |k, v|
        request.env['rack.session'][k] = v
      end

      loc_hdr = { 'Location' => RackSessionManipulation.config.path }
      [303, headers(0).merge(loc_hdr), '']
    rescue JSON::ParserError
      [400, headers(0), '']
    end
  end
end
