# Parent namespace for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # Rack middleware that handles the accessing and modification of session
  # state.
  class Middleware
    # Primary entry point of this middleware. Every request that makes it this
    # far into the stack will be parsed and when it matches something this
    # middleware is designed to handle it will stop the chain and process it
    # appropriately.
    #
    # @param [Hash] env An environment hash containing everything about the
    #   client's request.
    # @return [Array<Fixnum, Hash, String>] A generated response to the
    #   client's request.
    def call(env)
      request = Rack::Request.new(env)

      action = get_action(request)
      action.nil? ? @app.call(env) : send(action, request)
    end

    # Setup the middleware with the primary application passed in, anything we
    # can't handle will be passed to this application.
    #
    # @param [Object#call] app A rack application that implements the #call
    #   method.
    def initialize(app)
      @app = app
      @routes = {
        'DELETE'  => :reset,
        'GET'     => :retrieve,
        'PUT'     => :update
      }
    end

    protected

    # Look up what HTTP method was used for this request. In the event the
    # client doesn't support all HTTP methods, the standard '_method' parameter
    # fall back is made available to override the method actually used.
    #
    # Normally the '_method' fall back is only accepted over the POST method,
    # however, Capybara drivers are only required to implement GET method and
    # so this does not require any particular method to support the override.
    #
    # When a GET method was used to provide data, a subtle issue can crop up.
    # URLs can't exceed 1024 characters. Generally this results in them being
    # truncated which in turn will cause a JSON parse error and no changes
    # being made to the session.
    #
    # @param [Rack::Request] request The request to analyze
    # @return [String] The decided on HTTP method
    def extract_method(request)
      return request.params['_method'].upcase if request.params['_method']
      request.request_method
    end

    # Considers the request and if it matches something this middleware handles
    # return the symbol matching the name of the method that should handle the
    # request.
    #
    # @param [Rack::Request] request The request to assess
    # @return [Symbol,Nil] Name of method to use or nil if this middleware
    #   should pass the request on to the app.
    def get_action(request)
      return unless request.path == RackSessionManipulation.config.path
      @routes[extract_method(request)]
    end

    # A helper mechanism to consistently generate common headers client will
    # expect.
    #
    # @param [Fixnum] length Byte size of the message body.
    # @return [Hash] The common headers
    def headers(length)
      {
        'Content-Length'  => length,
        'Content-Type'    => 'application/json; charset=utf-8'
      }
    end

    # Handle requests to entirely reset the session state.
    #
    # @param [Rack::Request] request
    # @return [Array<Fixnum, Hash, String>]
    def reset(request)
      request.env['rack.session'].clear
      [204, headers(0), '']
    end

    # Retrieve the entire contents of the session and properly encode it
    # before returning.
    #
    # @param [Rack::Request] request
    # @return [Array<Fixnum, Hash, String>]
    def retrieve(request)
      session_hash = request.env['rack.session'].to_hash
      content = RackSessionManipulation.config.encoder.encode(session_hash)

      [200, headers(content.length), content]
    end

    # Update the current state of the session with the provided data. This
    # works effectively like a hash merge on the current session only setting
    # and overriding keys in the session data provided.
    #
    # @param [Rack::Request] request
    # @return [Array<Fixnum, Hash, String>]
    def update(request)
      session_data = request.params['session_data']
      RackSessionManipulation.config.encoder.decode(session_data).each do |k, v|
        request.env['rack.session'][k] = v
      end

      loc_hdr = { 'Location' => RackSessionManipulation.config.path }
      [303, headers(0).merge(loc_hdr), '']
    rescue JSON::ParserError
      [400, headers(0), '']
    end
  end
end
