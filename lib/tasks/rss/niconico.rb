# docker-compose exec app bundle exec rails runner Tasks::Rss::Niconico.rescue_execute
require 'net/http'
require 'rss'
class Tasks::Rss::Niconico < Tasks::Base
  def self.execute
    bulk_insert_video = []
    Commentator.niconico.find_each do | commentator |
      endpoint = "https://www.nicovideo.jp/user/#{commentator.user_id}/mylist?rss=2.0"
      response = Net::HTTP.get(URI.parse(endpoint))
      next if response.blank?

      Hash.from_xml(response)['rss']['channel']['item'].each do | item |
        title = item['title'].first
        api_result = search_video_contents(title)
        next if api_result.blank? || api_result['data'].blank?

        content_id = api_result['data'].first['contentId']
        video = Video.find_by(content_id: content_id)
        id = video.blank? ? nil : video.id
        params = { commentator: commentator, item: item, api_result: api_result, content_id: content_id }
        bulk_insert_video << build_video(id, params, video&.created_at)
      end
    end
    Video.upsert_all(bulk_insert_video) if bulk_insert_video.present?
  end

  private

  # call niconico contents api
  def self.search_video_contents(title)
    endpoint = "https://api.search.nicovideo.jp/api/v2/video/contents/search"
    url = URI.parse(endpoint)
    params = Hash.new
    params.store('q', title)
    params.store('targets', 'title')
    params.store('fields', 'description,startTime,thumbnailUrl,userId,contentId,title,viewCounter')
    params.store('_sort', '-viewCounter')
    params.store('_context', 'apiguide')
    url.query = URI.encode_www_form(params)
    req = Net::HTTP::Get.new(url)
    try = 0
    begin
      try += 1
      res = Net::HTTP.start(url.host, url.port, :use_ssl => true ) {|http|
        http.request(req)
      }
      raise 'unknown error' if res.code != '200' && res.code != '400'
    rescue
      ExceptionNotifier.notify_exception(e, :env => Rails.env, :data => {:message => title})
      sleep 2
      retry if try < 3
      return nil
    end
    JSON.parse(res.body)
  end

  def self.build_video(id, params, created_at)
    commentator = params[:commentator]
    api_result = params[:api_result]
    { 
      id: id,
      commentator_id: commentator.id, 
      content_id: params[:content_id],
      title: api_result['data'].first['title'],
      link: params[:item]['link'], 
      description: api_result['data'].first['description'],
      thumbnail_url: api_result['data'].first['thumbnailUrl'],
      published_at: DateTime.parse(api_result['data'].first['startTime']).strftime('%Y/%m/%d %H:%M:%S'),
      view_count: api_result['data'].first['viewCounter'],
      created_at: created_at ? created_at : Time.now,
      updated_at: Time.now 
    }
  end
end
