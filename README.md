# GithubNotificationsAgent

Huginn agent to fetch Github notifications

## Installation

Add this string to your Huginn's .env `ADDITIONAL_GEMS` configuration:

```ruby
huginn_github_notifications_agent
# when only using this agent gem it should look like hits:
ADDITIONAL_GEMS=huginn_github_notifications_agent
```

And then execute:

    $ bundle

## Usage

The GithubNotificationsAgent fetches your notifications from Github.

You need to create a [personal access token](https://github.com/settings/tokens) to use this, only the `notifications` scope is necessary.

To emit all new notifications as a single event, change `events` to `single`. The event key will be `notifications`.

To fetch all (unread) notifications, change `last_modified` to `false`. Default behaviour is to only fetch notifications that are updated since last run.

More options might be added for the [API](https://developer.github.com/v3/activity/notifications/#list-your-notifications).

## Development

Running `rake` will clone and set up Huginn in `spec/huginn` to run the specs of the Gem in Huginn as if they would be build-in Agents. The desired Huginn repository and branch can be modified in the `Rakefile`:

```ruby
HuginnAgent.load_tasks(branch: '<your branch>', remote: 'https://github.com/<github user>/huginn.git')
```

Make sure to delete the `spec/huginn` directory and re-run `rake` after changing the `remote` to update the Huginn source code.

After the setup is done `rake spec` will only run the tests, without cloning the Huginn source again.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/joenas/huginn_github_notifications_agent/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
