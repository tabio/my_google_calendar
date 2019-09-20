# MyGoogleCalendar

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/my_google_calendar`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'my_google_calendar'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install my_google_calendar

## Usage

### get credentials
```ruby
credentials = MyGoogleCalendar::MyAuth.credentials('my_files/client_secret.json', 'my_files/google_api_token.yaml', 'hoge@example.com')

# if you cann't get credentials and need to use google calendar code
credentials = MyGoogleCalendar::MyAuth.credentials('my_files/client_secret.json', 'my_files/google_api_token.yaml', 'hoge@example.com', code = 'token from google calendar')
```

### register calendar event
```ruby
MyGoogleCalendar::Calendar.register!(credentials, your_calendar_id, summary, start_date_at, end_date_at)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/my_google_calendar. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MyGoogleCalendar project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/my_google_calendar/blob/master/CODE_OF_CONDUCT.md).
