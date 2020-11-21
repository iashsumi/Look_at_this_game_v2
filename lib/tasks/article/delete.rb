# frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Article::Delete.rescue_execute
require "open-uri"
require "nokogiri"
require "json"
require "addressable/uri"

class Tasks::Article::Delete < Tasks::Base
  class << self
    # Article、dynamoDB、S3の画像と記事を削除
    def execute(target)
      client = S3.new
      d_client = Dynamo.new if Rails.env != "development"
      target.each do |article|
        ActiveRecord::Base.transaction do
          client.delete_object(article.id.to_s)
          client.delete_folder("matome/#{article.id}", "look-at-this-game-public")
          d_client.delete_item("matome-#{article.id}") if Rails.env != "development"
          article.delete
        rescue StandardError => e
          ExceptionNotifier.notify_exception(e, env: Rails.env, data: { message: article.id })
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end
