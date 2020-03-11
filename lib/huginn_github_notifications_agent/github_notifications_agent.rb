# frozen_string_literal: true

module Agents
  class GithubNotificationsAgent < Agent
    cannot_receive_events!
    can_dry_run!

    default_schedule 'every_10m'

    description <<-MD
      The GithubNotificationsAgent fetches your notifications from Github.

      You need to create a [personal access token](https://github.com/settings/tokens) to use this, only the `notifications` scope is necessary.

      To emit all new notifications as a single event, change `events` to `single`. The event key will be `notifications`.

      To fetch all (unread) notifications, change `last_modified` to `false`. Default behaviour is to only fetch notifications that are updated since last run.

      More options might be added for the [API](https://developer.github.com/v3/activity/notifications/#list-your-notifications).

      This agent also adds two more fields to `subject` in the response, `url_web` and `repo_name`. These are for convenience, if you want to link to the updated resource for example.
      ```
      "subject": {
        "url_web": "https://github.com/joenas/huginn_github_notifications/pull/1234",
        "repo_name": "joenas/huginn_github_notifications"
      }
      ```

    MD

    def default_options
      {
        'access_token' => 'my_gh_access_token',
        'events' => 'multiple',
        'last_modified' => true
      }
    end

    def validate_options
      unless options['access_token'].present?
        errors.add(:base, 'access_token is required ')
      end
      # rubocop:disable Style/GuardClause
      if last_modified.present? && boolify(last_modified).nil?
        errors.add(:base, 'last_modified must be a boolean value')
      end
      # rubocop:enable Style/GuardClause
    end

    def working?
      !recent_error_logs?
    end

    # TODO: Fix
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def check
      response = HTTParty.get base_url, request_options
      # If there are no new notifications, you will get a "304 Not Modified"
      return if response.code == 304

      notifications = JSON.parse(response.body)
      if response.code > 400
        error("Error during http request: #{response.body}")
        return
      end
      notifications.each do |notif|
        data = notif['subject'].merge(
          repo_name: notif['repository']['full_name']
        )
        subject = ::HuginnGithubNotificationsAgent::Subject.new(data)
        notif['subject'] = subject.to_h
      end
      if emit_single_event?
        create_event payload: { notifications: notifications }
      else
        notifications.each { |notification| create_event payload: notification }
      end
      memory[:last_modified] = response.headers['last-modified']
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    private

    def emit_single_event?
      options['events'] == 'single'
    end

    def last_modified
      options['last_modified']
    end

    def use_last_modified?
      memory[:last_modified].present? && boolify(last_modified)
    end

    def base_url
      'https://api.github.com/notifications'
    end

    def request_options
      {
        headers: default_headers.merge(extra_headers)
      }
    end

    def default_headers
      {
        'User-Agent' => 'Huginn (https://github.com/cantino/huginn)',
        'Authorization' => 'token ' + interpolated['access_token']
      }
    end

    def extra_headers
      if use_last_modified?
        { 'If-Modified-Since' => memory[:last_modified] }
      else
        {}
      end
    end
  end
end
