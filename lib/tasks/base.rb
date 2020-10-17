# frozen_string_literal: true

class Tasks::Base
  def self.rescue_execute
    notifier = Slack::Notifier.new(Rails.application.credentials.slack_url, channel: "#notification")
    notifier.ping("START #{self.class.name}")
    execute
    notifier.ping("END #{self.class.name}")
  rescue StandardError => e
    ExceptionNotifier.notify_exception(e, env: Rails.env, data: { message: "error" })
  end

  def self.execute
    raise "need override!!"
  end
end
