require 'json'

require 'rack_session_manipulation/config'
require 'rack_session_manipulation/json_encoder'
require 'rack_session_manipulation/middleware'
require 'rack_session_manipulation/version'

# RackSessionManipulation is rack middleware designed to expose internal
# session information to be read and modified from within tests.
module RackSessionManipulation
end
