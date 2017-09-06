# Hanami::Monban

**Hanami::Monban** is an authentication wrapper written for the Hanami web framework. It features session-based authentication as well as secure password-hashing and storage.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hanami-monban'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hanami-monban
    
If the majority of your actions will require session-based authentication running in before-hooks, add to / modify the controller configuration block in your app's `application.rb`

```ruby
controller.prepare do
  include Hanami::Monban::Auth
  before :authenticate!
end
```

## Usage

### Sessions

To **login** a `user`, simply

```ruby
login(user)
```

And to **logout**

```ruby
logout
```

To get the user stored by the current session

```ruby
current_user
```
You can conventiently ask if the session is currently authenticated by

```ruby
authenticated?
```

To tell the system to authenticate (and redirect if that's impossible)

```ruby
authenticate!
```
which will redirect to a route named `sign_in_path`. This route may be customized.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hanami-monban.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


