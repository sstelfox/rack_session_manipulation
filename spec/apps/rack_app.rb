require 'rack'

RackApp = Rack::Builder.new do
  use Rack::Session::Cookie
  use RackSessionManipulation::Middleware

  run -> (_env) { [200, { 'Content-Type' => 'text/plain' }, 'Hello World!'] }
end.to_app
