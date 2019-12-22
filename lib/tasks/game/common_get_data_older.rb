# 昔のゲーム情報の取得用
class Tasks::Game::CommonGetDataOlder
  def self.create_data(url, positions, kind, year = nil, years_hash = nil)
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)

    positions.each do | i |
      doc.xpath("//*[@id='mw-content-text']/div/ul[#{i}]").each do |node|
        # 年取得データ(yyyy)
        year = node.xpath("preceding-sibling::h2").last.text[0, 4] if year.blank? && years_hash.blank?
        year = years_hash[i] if years_hash.present?
        mmdd = nil
        publish = nil
        title = nil
        node.xpath('.//li').each do |children|
          # mm/dd取得
          mmdd = date_checker(children.xpath('.//text()').text)
          # 出版社
          publish_tmp_matcher = children.xpath('.//text()').text.match('（.*?）')
          publish_tmp = publish_tmp_matcher[0] if publish_tmp_matcher.present?
          if publish_tmp.present?
            # 先頭の(を削除
            publish_tmp.slice!(0)
            # 最後の)を削除
            publish_tmp.chop! 
            # カンマを起点に配列にし、最初の要素を取得
            publish = publish_tmp.split('、')[0] 
          end
          #title
          title = children.xpath('.//a').first.text if children.xpath('.//a').first.present?
          detail_url = nil
          if children.xpath('.//a').first.present?
            detail_url = "https://ja.wikipedia.org/#{children.xpath('.//a').first.values.first}" unless children.xpath('.//a').first.values.last.include?('存在しないページ')
          end
          # 空のデータは除外
          next if title.blank?
          # 日付不明もあるのでチェック
          datetime = nil
          begin
            datetime = DateTime.parse(year + '/' + mmdd) if mmdd.present?
          rescue => exception
            p exception.message
            p title
          end
          # 登録
          Game.new(title: title, release_date_at: datetime, publisher: publish, kind: kind).insert
        end
      end
    end
  end

  def self.date_checker(text)
    first_index = text.index('月')
    return if first_index.blank?
    second_index = text.index('日')
    return if second_index.blank?

    month = text.slice(0, first_index)
    day = text.slice(first_index + 1, second_index - first_index -1 )

    # 数字チェック
    mounth = nil unless month.to_i.to_s == month.to_s
    day = nil unless day.to_i.to_s == day.to_s
    month + '/' + day if month.present? && day.present?
  end
end