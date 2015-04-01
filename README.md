# RackSessionManipulation

[![Gem Version](https://badge.fury.io/rb/rack_session_manipulation.svg)](https://rubygems.org/gems/rack_session_manipulation)
[![Build Status](https://travis-ci.org/sstelfox/rack_session_manipulation.svg)](https://travis-ci.org/sstelfox/rack_session_manipulation)
[![Coverage Status](https://coveralls.io/repos/sstelfox/rack_session_manipulation/badge.svg?branch=develop)](https://coveralls.io/r/sstelfox/rack_session_manipulation?branch=develop)
[![Dependency Status](https://gemnasium.com/sstelfox/rack_session_manipulation.svg)](https://gemnasium.com/sstelfox/rack_session_manipulation)
[![Code Climate](https://codeclimate.com/github/sstelfox/rack_session_manipulation/badges/gpa.svg)](https://codeclimate.com/github/sstelfox/rack_session_manipulation)
[![Yard Docs](http://img.shields.io/badge/yard-docs-green.svg)](http://www.rubydoc.info/gems/rack_session_manipulation)

RackSessionManipulation is rack middleware designed to expose internal session
information to be read and modified from within tests. This is intended to
assist in treating routes as modular units of work that can be tested in
isolation without the dependency of the rest of your application.

This is not intended to replace full set of 'behavior' tests, but can be used
to speed up getting to a 'Given' state in place of helpers that previously
would be forced to walk through your entire application stack to establish the
target state. That walkthrough is valuable but can be redundant and unecessary.

This middleware should never be used in production as it allows arbitrary
tampering of encrypted server-side session information without any form of
authentication. Use in production can lead to abuses such as user
impersonation, privilege escalation, and private information exposure depending
on what the application stores in the session.

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

## Contributing

1. Reivew the [Contributor Code of Conduct](CODE_OF_CONDUCT.md)
2. Fork it ( https://github.com/sstelfox/rack_session_manipulation/fork )
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
