# frozen_string_literal: true

class Videos::IndexViewModel
  def initialize(videos)
    @videos = videos
  end

  def to_json(*_args)
    {
      videos: fetch_videos,
      meta: {
        total_count: @videos.total_count,
        total_pages: @videos.total_pages,
        current_page: @videos.current_page
      }
    }
  end

  private
    def fetch_videos
      @videos.includes(:commentator).map do |video|
        {
          id: video.id,
          site_kbn: video.commentator.site_kbn,
          commentator_id: video.commentator_id,
          commentator_name: video.commentator.name,
          commentator_thumbnail_url: video.commentator.thumbnail_url,
          content_id: video.content_id,
          title: video.title,
          link: video.link,
          description: video.description,
          thumbnail_url: video.thumbnail_url,
          published_at: video.published_at.strftime("%Y/%m/%d %H:%M:%S"),
          view_count: video.view_count,
          updated_at: video.updated_at.strftime("%Y/%m/%d %H:%M:%S")
        }
      end
    end
end
