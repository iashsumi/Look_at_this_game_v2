# frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Board::Exec.rescue_execute
require "open-uri"
require "nokogiri"
require "json"
require "addressable/uri"

class Tasks::Board::Exec < Tasks::Base
  def self.execute
    client = S3.new
    service = Tasks::Board::Service.new
    # スレ更新
    service.update_thread
    # 勢い計算
    service.calc_momentum
    # 各板の勢いの強い順に並び替え、スクレピングしてコメをまとめる
    complete = []
    limit = Configuration.all.first.value.to_i
    ScThread.where.not(momentum: 0).great.where("res > before_res").limit(limit).each do |item|
      fetched_data, meta = service.fetch_res(item.url)
      next if fetched_data.blank?

      # S3 UPLOAD
      client.put_object("sc_thread_keywords/#{item.id}", JSON.dump(meta))
      client.put_object(item.id.to_s, JSON.dump(fetched_data))
      res = fetched_data.find { |i| i[:images].present? }
      item.thumbnail_url = res[:images].first if res.present?
      item.is_completed = true
      complete << item

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

    # まとめサイト作成
    create_article
  end

  def self.create_article(from = nil, to = nil)
    if from.nil? && to.nil?
      from = DateTime.current.prev_day(1)
      to = DateTime.current.next_day(1)
    end

    # キーワード取得(ラベリング済)
    target = ScThreadKeyword.eager_load(:sc_thread).merge(ScThread.range(from, to)).merge(ScThread.labeling).merge(ScThread.where(is_completed: true))
    key_words = []
    target.each do | obj |
      # ラベルと同じものはSKIP ドラクエ ドラクエみたいな検索避けるため
      next if obj.word == obj.sc_thread.label

      uri = Addressable::URI.parse("http://www.google.com/complete/search?hl=jp&q=#{obj.sc_thread.label} #{obj.word}&output=toolbar")
      response = Net::HTTP.get_response(uri.normalize)
      next if response.body.blank?

      result =  Hash.from_xml(response.body)&.dig("toplevel", "CompleteSuggestion")
      next if result.blank?

      # 上記APIのMAXの件数(多少のフィルターにはなるはず)
      key_words << obj if result.length >= 10
    end
    return if key_words.blank?

    client = S3.new
    cache = []
    key_words.each do | obj |
      # S3から元のスレのまとめ取得
      selected = cache.find { |i| i[:id] == obj.sc_thread_id }
      data = nil
      if selected.blank?
        data = client.fetch_object("#{obj.sc_thread_id}")
        cache << { id: obj.sc_thread_id, data: data }
      else
        data = selected[:data]
      end
      next if data.blank?

      # 記事作成
      matome = []
      JSON.parse(data).each do | detail |
        # 自身のm_tags確認
        if detail["m_tags"].include?(obj.word)
          matome << detail
          next
        end
        # children確認
        matome << detail if detail["children"].find { |child| child["m_tags"].include?(obj.word) }
      end

      # データ作成
      article = Article.find_or_create_by(game: obj.sc_thread.game, sc_thread: obj.sc_thread, key_word: obj.word)
      next if article.blank?

      # 画像保存(look-at-this-game-public)+データ整形
      comments = []
      images = []
      matome.each do | i |
        new_images = []
        i["images"].each do | path |
          images << path
          name = SecureRandom.uuid
          client.put_object("matome/#{article.id}/#{name}", open(path), "look-at-this-game-public")
          new_image_path = "https://look-at-this-game-public.s3-ap-northeast-1.amazonaws.com/matome/#{article.id}/#{name}"
          new_images << new_image_path
        end
        i["new_images"] = new_images
        # タグ、URLを除去
        i["text"] = ActionController::Base.helpers.strip_tags(i["text"]).gsub(/&gt;&gt;[0-9]*/, "")
        URI.extract(i["text"]).uniq.each { |url| i["text"].gsub!(url, "") }
        # &gt;270,272,274  なるほど、そんなシステムだったのね  せっかくマックスアーマー4凸まで育てたし、頑張ってAまではやっておくかこういうのもあるのでゴミ削除
        i["text"].gsub!(/&gt;\b\d{1,3}(,\d{3})*\b/, '')
        i["text"].strip!
        i["children_count"] = i["children"].length
        comments << i["text"] if i["text"].length < 50

        i["children"].each do | child |
          new_images = []
          child["images"].each do | path |
            images << path
            name = SecureRandom.uuid
            client.put_object("matome/#{article.id}/#{name}", open(path), "look-at-this-game-public")
            new_image_path = "https://look-at-this-game-public.s3-ap-northeast-1.amazonaws.com/matome/#{article.id}/#{name}"
            new_images << new_image_path
          end
          child["new_images"] = new_images
          child["text"] = ActionController::Base.helpers.strip_tags(child["text"]).gsub(/&gt;&gt;[0-9]*/, "")
          URI.extract(child["text"]).uniq.each { |url| child["text"].gsub!(url, "") }
          child["text"].gsub!(/&gt;\b\d{1,3}(,\d{3})*\b/, '')
          child["text"].strip!
        end
      end
      article.title = "【#{article.game.title_min}】#{comments.first}" if article.title.blank?
      article.comments = comments.join("\n")
      article.image_paths = images.join("\n")
      article.thumbnail_url = images.first
      article.is_published = (emoji_contained?(article.title) || comments.first.blank? || Article.where(sc_thread: obj.sc_thread, is_published: true).present?) ? false : true
      article.save

      # S3にアップ
      client.put_object("matome/#{article.id}", JSON.dump(matome))

      # OGP対応
      if Rails.env != "development"
        d_client = Dynamo.new
        next if d_client.get_item("matome-#{article.id}").present?
        d_params = { id: "matome-#{article.id}", title: article.title, description: "#{article.game.title}(#{article.game.title_min})の#{article.key_word}に関する情報をまとめました。", image_path: article.thumbnail_url }
        d_client.update_item(d_params)
      end
    end
  end

  def self.emoji_contained?(text)
    text&.each_char&.any? {|c| c.bytesize == 4 } || false
  end
end
