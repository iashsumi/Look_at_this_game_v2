# frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Article::Create.rescue_execute
require "open-uri"
require "nokogiri"
require "json"
require "addressable/uri"

class Tasks::Article::Create < Tasks::Base
  class << self
    def execute(from = nil, to = nil, target = nil)
      if from.nil? && to.nil?
        from = DateTime.current.prev_day(1)
        to = DateTime.current.next_day(1)
      end

      if target.blank?
        # キーワード取得(ラベリング済)
        target = ScThreadKeyword.eager_load(:sc_thread).merge(ScThread.range(from, to)).merge(ScThread.labeling).merge(ScThread.where(is_completed: true))
      end

      key_words = []
      cache = []
      target.each do | obj |
        # ラベルと同じものはSKIP ドラクエ ドラクエみたいな検索避けるため
        next if obj.word == obj.sc_thread.label

        key_words << obj
      #   key = "#{obj.sc_thread.label} #{obj.word}"
      #   data = cache.uniq.find { |i| i[:key] == key }
      #   if data.present?
      #     key_words << obj if data[:result]
      #     next
      #   end
      #   uri = Addressable::URI.parse("http://www.google.com/complete/search?hl=jp&q=#{key}&output=toolbar")
      #   response = Net::HTTP.get_response(uri.normalize)
      #   next if response.body.blank?

      #   begin
      #     result = Hash.from_xml(response.body.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: ''))&.dig("toplevel", "CompleteSuggestion")
      #   rescue StandardError => e
      #     ExceptionNotifier.notify_exception(e, env: Rails.env, data: { message: key })
      #     next
      #   end
      #   # 上記APIのMAXの件数(多少のフィルターにはなるはず)
      #   if result.present? && result.length >= 10
      #     key_words << obj
      #     cache << { key: key, result: true }
      #     next
      #   end
      #   cache << { key: key, result: false }
      # end
      # return if key_words.blank?

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
        # 公開済のものは編集しない
        next if article.is_published

        # 画像保存(look-at-this-game-public)
        comments = []
        images = []
        matome.each do | i |
          new_images = []
          # URL除去
          URI.extract(i["text"]).uniq.each { |url| i["text"].gsub!(url, "") }
          i["images"].each do | path |
            images << path
            new_images << build_new_image_path(client, article, path)
          end
          i["new_images"] = new_images.compact
          i["children"].each do | child |
            new_images_child = []
            # URL除去
            URI.extract(child["text"]).uniq.each { |url| child["text"].gsub!(url, "") }
            child["images"].each do | path |
              images << path
              new_images_child << build_new_image_path(client, article, path)
            end
            child["new_images"] = new_images_child.compact
          end

          # タグ、URLを除去
          comment = ActionController::Base.helpers.strip_tags(i["text"]).gsub(/&gt;&gt;[0-9]*/, "")
          URI.extract(comment).uniq.each { |url| comment.gsub!(url, "") }
          # &gt;270,272,274  なるほど、そんなシステムだったのね  せっかくマックスアーマー4凸まで育てたし、頑張ってAまではやっておくかこういうのもあるのでゴミ削除
          comment.gsub!(/&gt;\b\d{1,3}(,\d{3})*\b/, "")
          comment.strip!
          comments << comment if comment.length <= 30
        end

        # S3にアップ
        client.put_object("matome/#{article.id}", JSON.dump(matome))

        article.title = "【#{article.game.title_min}】#{comments.first}" if article.title.blank?
        article.comments = comments.join("\n")
        article.image_paths = images.join("\n")
        article.thumbnail_url = images.first
        article.is_published = (emoji_contained?(article.title) || comments.first.blank? || Article.where(sc_thread: obj.sc_thread, is_published: true).present?) ? false : true
        article.save

        # OGP対応
        # 未公開はOGP対応しない
        next unless article.is_published

        if Rails.env != "development"
          d_client = Dynamo.new
          next if d_client.get_item("matome-#{article.id}").present?
          d_params = { id: "matome-#{article.id}", title: article.title, description: "#{article.game.title}(#{article.game.title_min})の#{article.key_word}に関する情報をまとめました。", image_path: article.thumbnail_url }
          d_client.update_item(d_params)
        end
      end
    end

    def emoji_contained?(text)
      text&.each_char&.any? { |c| c.bytesize == 4 } || false
    end

    def build_new_image_path(client, article, path)
      tmp_image = open(path)
      # imgur.comはno imageの場合,StringIOになるので除外(他はわからないがほとんどimgur.comなので一旦これで)
      if tmp_image.class == "StringIO"
        return "NoImage"
      end
      image_key = Digest::SHA256.hexdigest(path)
      client.put_object("matome_images/#{article.id}/#{image_key}", tmp_image, "look-at-this-game-public")
      image_key
    end
  end
end
