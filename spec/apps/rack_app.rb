require 'rack'

# This module is a very barebones rack application that provides just enough
# functionality to confirm session modification and access to / from tests.
module HelloReflector
  def self.call(env)
    request = Rack::Request.new(env)
    request.env['rack.session'].merge!('reflection' => request.path)

    content = format('Hello World! %s', request.env['rack.session']['return'])
    [200, { 'Content-Type' => 'text/plain' }, content]
  end
end

RackApp = Rack::Builder.new do
  use Rack::Session::Cookie, secret: 'random-unimportant-string'
  use RackSessionManipulation::Middleware

  run HelloReflector
end.to_app
