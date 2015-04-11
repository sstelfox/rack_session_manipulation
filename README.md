# RackSessionManipulation

[![Gem Version](https://badge.fury.io/rb/rack_session_manipulation.svg)](https://rubygems.org/gems/rack_session_manipulation)
[![Build Status](https://travis-ci.org/sstelfox/rack_session_manipulation.svg)](https://travis-ci.org/sstelfox/rack_session_manipulation)
[![Coverage Status](https://coveralls.io/repos/sstelfox/rack_session_manipulation/badge.svg?branch=develop)](https://coveralls.io/r/sstelfox/rack_session_manipulation?branch=develop)
[![Dependency Status](https://gemnasium.com/sstelfox/rack_session_manipulation.svg)](https://gemnasium.com/sstelfox/rack_session_manipulation)
[![Code Climate](https://codeclimate.com/github/sstelfox/rack_session_manipulation/badges/gpa.svg)](https://codeclimate.com/github/sstelfox/rack_session_manipulation)
[![Yard Docs](http://img.shields.io/badge/yard-docs-green.svg)](http://www.rubydoc.info/gems/rack_session_manipulation)

RackSessionManipulation is rack middleware designed to expose internal session
information to be read and modified from within tests (primarily for use within
Capybara). This is intended to assist in treating routes as modular units of
work that can be tested in isolation without the dependency of the rest of your
application.

This is not intended to replace full set of 'behavior' tests, but can be used
to speed up getting to a 'Given' state in place of helpers that previously
would be forced to walk through your entire application stack to establish the
target state. That walkthrough is valuable but can be redundant and unecessary
when they are only used to setup other tests.

RackSessionManipulation strives to be a lightweight and safe, while having a
high quality code base following the best ruby practices.

## Security Notice

This middleware should never be used in production as it allows arbitrary
tampering of encrypted server-side session information without any form of
authentication. Use in production can lead to abuses such as user
impersonation, privilege escalation, and private information exposure depending
on what the application stores in the session.

## Alternatives

There is a very similar rack middleware [RackSessionAccess][1] that
accomplishes more or less the same task. I wasn't particularly fond of how that
gem solved the updating of state using multiple requests, and marshalled
objects as well as unecessary use of builder. The approach seemed more
complicated, slower and more dangerous than necessary.

If you are looking to test a specific session state from a pure rack/test unit
perspective, you don't need this gem. The native rack/test HTTP methods provide
the mechanism to directly set and test state like so:

```
session_data = { 'user_id' => 5 }
get '/test_path', {}, { 'rack.session' => session_data }
```

The above will make a get request to '/test_path' with the session state
contained within the `session_data` variable.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack_session_manipulation'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack_session_manipulation

## Usage

The middleware is useful on it's own, but this gem's primary power comes from
it's integration with Capybara. On it's own or with capybara, the first step is
to inject the middleware. This varies from framework to framework, the most
common examples I've provided below.

### Rack

The following is a super simple rack app that at a minimum can be used as a
fallback definition for any Ruby web application by replacing the `YourApp`
constant with your application (generally this is what is passed to `run` in
your 'config.ru' file. At the same time you'll want to replace the value in
your 'config.ru' file with the constant `YourAwesomeRackStack` (though you can
change that as you'd like).

```ruby
YourAwesomeRackStack = Rack::Builder.new do
  # To access sessions they must first exist. Configure the appropriate Rack
  # session mechanism prior to using this middleware.
  use Rack::Session::Cookie, secret: 'some secret string'

  # Add this middleware to the stack
  use RackSessionManipulation::Middleware

  # Finally, running your own App at the top of the stack
  run YourApp
end.to_app
```

### Sinatra

TODO

### Rails

TODO

### Capybara Usage

After setting up the middleware and Capybara as you would normally, the only
additional setup is requiring the Capybara helpers (you generally want to add
this line after the 'capybara' require):

```ruby
require 'rack_session_access/capybara'
```

After that anywhere you are using Capybara you will have three additional
methods available to you:

* `reset_session`: Clear the entire contents of the existing session.
* `session`: Get a hash representing the current session state.
* `session=`: additional data into the current session.

When setting the session, you'll want to provide a hash. The values at the top
level keys of the hash will replace the equivalent keys in the current session.
Any keys that existed before but aren't getting set will continue to exist. It
works like a simple Hash merge. The other methods are fairly self explanatory.

## Contributing

I welcome new ideas, bug fixes and comments from anyone and strive to take no
longer than a week to respond to issues, PRs, or various comments.

All code submitted through PRs will be licensed under this project's MIT
license, if this is a problem please instead open an issue before making your
changes indicating this and I depending on the request I may make the requested
changes myself or attempt to convince about the usage of this license. I want
to avoid a multi-license code base that may impede any individual's usage of
this code.

With all that said, if you'd like to contribute please follow the standard
contribution guide:

1. Review the [Contributor Code of Conduct][2]
2. Fork it ( https://github.com/sstelfox/rack_session_manipulation/fork )
3. Create your feature branch (`git checkout -b my-new-feature develop`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request against this repo's develop branch

Code in the master branch is the latest released version. All code that has
made it into the develop branch is staged for the next release. All tests must
be passing before the code will get merged into develop. Along those lines,
please write tests to cover bugs found or features added!

[1]: https://github.com/railsware/rack_session_access
[2]: CODE_OF_CONDUCT.md
