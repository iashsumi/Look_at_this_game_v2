# frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Rss::Youtube.rescue_execute
require "net/http"
require "rss"
class Tasks::Rss::Youtube < Tasks::Base
  def self.execute
    bulk_insert_video = []
    Commentator.youtube.find_each do |commentator|
      endpoint = "https://www.youtube.com/feeds/videos.xml?channel_id=#{commentator.user_id}"
      response = Net::HTTP.get(URI.parse(endpoint))
      next if response.blank?

      Hash.from_xml(response)["feed"]["entry"].each do |item|
        content_id = item["videoId"]
        video = Video.find_by(content_id: content_id)
        id = video.blank? ? nil : video.id
        params = { commentator: commentator, item: item, content_id: content_id }
        bulk_insert_video << build_video(id, params, video&.created_at)
      end
    rescue StandardError => e
      ExceptionNotifier.notify_exception(e, env: Rails.env, data: { message: commentator.id })
    end
    Video.upsert_all(bulk_insert_video) if bulk_insert_video.present?
  end

  private
    def self.build_video(id, params, created_at)
      commentator = params[:commentator]
      {
        id: id,
        commentator_id: commentator.id,
        content_id: params[:content_id],
        title: params[:item]["title"],
        link: params[:item]["link"]["href"],
        description: params[:item]["group"]["description"],
        thumbnail_url: params[:item]["group"]["thumbnail"]["url"],
        published_at: DateTime.parse(params[:item]["published"]).strftime("%Y/%m/%d %H:%M:%S"),
        view_count: params[:item]["group"]["community"]["statistics"]["views"],
        created_at: created_at || Time.now,
        updated_at: Time.now
      }
    end
end
