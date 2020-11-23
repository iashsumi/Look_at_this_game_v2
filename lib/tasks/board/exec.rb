# frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Board::Exec.rescue_execute
require "open-uri"
require "nokogiri"
require "json"
require "addressable/uri"

class Tasks::Board::Exec < Tasks::Base
  def self.execute(target_threads = nil)
    client = S3.new
    service = Tasks::Board::Service.new
    # スレ更新
    service.update_thread
    # 勢い計算
    service.calc_momentum
    if target_threads.blank?
      limit = Configuration.all.first.value.to_i
      target_threads = ScThread.where(is_backup: true, is_completed: false).limit(limit)
    end

    target_threads.each do |item|
      dat = client.fetch_object("backup/#{item.id}")
      fetched_data, meta = service.fetch_res(item.url, dat)
      next if fetched_data.blank?

      item.is_completed = true
      item.save!

      # キーワード設定
      builds = []
      meta[:m_tag_all].each do | k |
        next if NgWord.kind_all.pluck(:word).include?(k[0])
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
    rescue StandardError => e
      ExceptionNotifier.notify_exception(e, env: Rails.env, data: { message: item.id })
    end
    # labeling
    labels = Label.all
    ups = []
    ScThread.where(game_id: nil).find_each do | i |
      if i.sc_board_id == 31
        i.label = "ポケモンGO"
        i.game_id = 218
        ups << i
      else
        selected = labels.select { |j| i.title.include?(j.word) }
        next if selected.blank?
        # 選択したものが同じラベルでない場合は通知
        if selected.pluck(:label).uniq.length > 1
          next
        end
        i.label = selected.first.label
        i.is_series = i.title.include?("総合")
        i.game_id = selected.first.game_id
        ups << i
      end
    end
    ScThread.import(ups, on_duplicate_key_update: [:label, :is_series, :game_id])
  end
end
