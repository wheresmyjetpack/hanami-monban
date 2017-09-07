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

If you've `include`ed `Hanami::Monban::Auth` in all actions by default (as in the installation step), you will likely need to skip the authorization callback on a case-by-case basis. An action responsible for logging in users is a good example of when we'd like to skip the `authenticate!` callback.

```ruby
module Web::Controllers::Sessions
  class New
    include Web::Action
    skip_auth
    ...
  end
end
```

`.skip_auth` will add some no-op methods to the action will which prevent the authenticate callback from logging the current user out.

### Secure Passwords

This feature requires your to store a field called `password_hash` associated to your user. In the case of an application backed by a relational database, this means adding a migration to add the `password_hash` field to your users table.

Instead of persisting a plain text password to disk, store the a hash of the password. `include` `Hanami::Monban::SecurePassword` in your `UserRepository`.

```ruby
UserRepository < Hanami::Repository
  include Hanami::Monban::SecurePassword
  ...
end
```

This will add `#create_secure` to the `UserRepository`, which should always be used in place of the standard `#create`.

```ruby
repo = UserRepository.new
repo.create_secure(username: 'UlrichLeeche', password: 'lizardtail')
```

This will save the password `'lizardtail'` as a hash in your data store, preventing someone who obtains a copy of your database from having the plain text password of every one of your users.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hanami-monban.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


