# frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Suggest::Exec.rescue_execute
require "addressable/uri"

# 作成してみたが、流石にデータ件数が多いので全件取ってくるのは無理っぽい
class Tasks::Suggest::Exec < Tasks::Base
  WORDS = %w(
    あ い う え お 
    か き く け こ 
    さ し す せ そ 
    た ち つ て と 
    な に ぬ ね の 
    は ひ ふ へ ほ 
    ま み む め も 
    ら り る れ ろ 
    わ を ん 
    が ぎ ぐ げ ご 
    ざ じ ず ぜ ぞ 
    だ ぢ づ で ど 
    ば び ぶ べ ぼ
    ぱ ぴ ぷ ぺ ぽ
    a b c d e f g h i j k l m n o p q r s t u v w x y z 
    1 2 3 4 5 6 7 8 9 0
  )
  def self.execute
    targets = Label.select(:label).distinct
    imports = []
    targets.each do | target |
      WORDS.each do | word |
        uri = Addressable::URI.parse("http://www.google.com/complete/search?hl=jp&q=#{target.label} #{word}&output=toolbar")
        response = Net::HTTP.get_response(uri.normalize)
        next if response.body.blank?

        result =  Hash.from_xml(response.body)
        result.dig('toplevel', 'CompleteSuggestion')&.each do | item |
          p item
          # 要素が１個しかないと配列になるのでチェック
          if item.is_a?(Array)
            imports << SuggestWord.new(label: target.label, suggest_word: item[1]['data'])
          else
            imports << SuggestWord.new(label: target.label, suggest_word: item['suggestion']['data'])
          end
        end
      rescue => e
        # invalid byte sequence in UTF-8 が起こる時があるのでその場合はSKIP
        ExceptionNotifier.notify_exception(e, env: Rails.env, data: { message: "#{target.label} #{word}" })
        next
      end
      sleep 1
    end
    ActiveRecord::Base.transaction do
      SuggestWord.where(label: targets.pluck(:label)).delete_all
      SuggestWord.import(imports)
    end
  end
end