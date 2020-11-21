# frozen_string_literal: true

require "open-uri"

class Function
  class << self
    def fetch_html(url)
      URI.open(url, "r:binary") do |f|
        f.read.encode("utf-8", "cp932", invalid: :replace, undef: :replace)
      end
    rescue StandardError => e
      ExceptionNotifier.notify_exception(e, env: Rails.env, data: { message: url })
      nil
    end
  end
end