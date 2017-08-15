module HuginnGithubNotificationsAgent
  class Subject
    include Virtus.model

    attribute :title, String
    attribute :url, String
    attribute :latest_comment_url, String
    attribute :type, String
    attribute :url_web, String
    attribute :repo_name, String

    def url_web
      matches = url.scan(/\/(?<type>pull|issues)s?\/(?<id>\d+)$/)
      (["https://github.com/#{repo_name}"] << matches.flatten).join('/')
    end
  end
end
