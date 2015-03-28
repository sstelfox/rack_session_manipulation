require 'rack'

module HelloReflector
  def self.call(env)
    request = Rack::Request.new(env)
    request.env['rack.session'].merge!(reflection: request.path)

    [200, { 'Content-Type' => 'text/plain' }, 'Hello World!']
  end
end

RackApp = Rack::Builder.new do
  use Rack::Session::Cookie, secret: 'random-unimportant-string'
  use RackSessionManipulation::Middleware

  run HelloReflector
end.to_app
