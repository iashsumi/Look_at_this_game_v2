# frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Board::Exec.rescue_execute
require "open-uri"
require "nokogiri"
require "json"

class Tasks::Board::Exec < Tasks::Base
  def self.execute
    client = S3.new
    service = Tasks::Board::Service.new
    # スレ更新
    service.update_thread
    # 各板の勢いの強い順に並び替え、スクレピングしてコメをまとめる
    complete = []
    descriptions = []
    ScThread.where.not(momentum: 0).great.where('res > before_res').limit(50).each do |item|
      fetched_data, meta = service.fetch_res(item.url)
      next if fetched_data.blank?

      # S3 UPLOAD
      client.put_object("sc_thread_keywords/#{item.id.to_s}", JSON.dump(meta))
      client.put_object(item.id.to_s, JSON.dump(fetched_data))
      res = fetched_data.find { |i| i[:images].present? }
      item.thumbnail_url = res[:images].first if res.present?
      item.is_completed = true
      complete << item

      # OGP対応
      descriptions << {id: item.id, text: fetched_data[1][:text]} 

      # キーワード設定
      builds = []
      meta[:m_tag_all].each do | k |
        next if NgWord.pluck(:word).include?(k[0])
        next if k[1] < 10
        
        target = ScThreadKeyword.new
        target.sc_thread_id = item.id
        # キーワード
        target.word = k[0]
        # キーワード出現回数
        target.appearances = k[1]
        target.is_used = false
        builds << target
      end
      ScThreadKeyword.where(sc_thread_id: item.id).delete_all
      ScThreadKeyword.import(builds)

      # 取得の間隔制御
      sleep 3
    end
    # データ更新
    ScThread.import(complete, on_duplicate_key_update: [:thumbnail_url, :is_completed])
    # 勢い計算
    service.calc_momentum
    # OGP対応のためDynamoDBに情報を保存
    if Rails.env != "development"
      d_client = Dynamo.new
      complete.each do | item |
        description = descriptions.find {|i| i[:id] == item.id  }[:text]
        image_path = item.thumbnail_url.present? ? item.thumbnail_url : item.board.thumbnail_url
        d_params = { id: "thread-#{item.id}", title: item.title, description: description, image_path: image_path  }
        d_client.update_item(d_params)
      end

      # twitterへ投稿
      messages = []
      tags = []
      t_client = TwitterClient.new
      send_data = complete.first
      messages << send_data.title
      messages << "https://www.latg.site/thread/#{send_data.id}"
      messages << "他 #{complete.length} 件 更新されました"
      tags = send_data.sc_thread_keywords.where('appearances >= 20').pluck(:word)
      t_client.tweet(messages, tags)
    end
  end
end
