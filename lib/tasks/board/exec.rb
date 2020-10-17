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
    # 各板の勢いの強い順に並び替え、TOP200に対してスクレピングしてコメをまとめる(勢いが0のものは取得しない)
    complete = []
    ScThread.where.not(momentum: 0).order(momentum: "DESC").limit(200).each do |item|
      fetched_data = service.fetch_res(item.url)
      next if fetched_data.blank?

      # S3 UPLOAD
      client.put_object(item.id.to_s, JSON.dump(fetched_data))
      complete << item.id
      # 取得の間隔制御
      sleep 3
    end
    # 更新完了フラグ立てる
    ScThread.where(id: complete).update_all(is_completed: true)
    # 勢い計算
    service.calc_momentum
  end
end
