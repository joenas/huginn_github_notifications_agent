# frozen_string_literal: true

# rubocop:disable Layout/LineLength

require 'huginn_agent'
require 'virtus'
require 'huginn_github_notifications_agent/subject'

# HuginnAgent.load 'huginn_github_notifications_agent/concerns/my_agent_concern'
HuginnAgent.register 'huginn_github_notifications_agent/github_notifications_agent'
# rubocop:enable Layout/LineLength
