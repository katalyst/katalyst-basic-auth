# Katalyst::Basic::Auth

This gem provides rails middleware to request basic authentication for all requests.
By default, this middleware is installed only for staging and uat rails environments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'katalyst-basic-auth'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install katalyst-basic-auth

## Usage

Add the gem to your project:

    $ bundler add katalyst-basic-auth

The following environment variables can optionally be defined to configure the gem

| Environment Variable | Description |
| ------ | ----- |
| KATALYST_BASIC_AUTH_ENABLED | If "yes" or "true", the middleware will be enabled. By default, the middleware is enabled on staging and uat Rails environments |
| KATALYST_BASIC_AUTH_USER | The username for basic authentication. Default is the Rails application name in lowercase. |
| KATALYST_BASIC_AUTH_PASS | The password for basic authentication. A password will be generated if not set. |

The gem provides a rake task that can be used to query basic auth settings:

    $ rake katalyst_basic_auth:info  

Additional paths can be password protected by adding configuration to an initializer. e.g.

    Katalyst::Basic::Auth.add("/secure-path", username: "user", password: "pass") if Rails.env.production?

The username and password parameters are optional. Use the rake task to find the default settings.

Paths can also be excluded from basic auth. e.g. to allow access to `/public` without basic authentication:

    Katalyst::Basic::Auth.exclude("/public")

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katalyst/katalyst-basic-auth. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/katalyst-basic-auth/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the katalyst-basic-auth project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/katalyst-basic-auth/blob/master/CODE_OF_CONDUCT.md).
