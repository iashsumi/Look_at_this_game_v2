# 最近のゲーム情報の取得用
class Tasks::Game::CommonGetDataNew
  def self.create_data(url, positions, kind, year = nil, years_hash = nil)
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)

    positions.each do | i |
      doc.xpath("//*[@id='mw-content-text']/div/table[#{i}]/tbody").each do |node|
        # テーブルを1行ずつ参照していく
        node.xpath(".//tr[position()>1]").each do | tr |
          year = years_hash[i] if years_hash.present?
          # 発売日
          mmdd = date_checker(tr.xpath(".//td[1]").text)
          datetime = nil
          datetime = DateTime.parse(year + '/' + mmdd) if mmdd.present?
          # 発売日がないものはSKIP
          next if datetime.blank?
          # タイトル
          title = tr.xpath(".//td[2]/a").first.text if tr.xpath(".//td[2]/a").first.present?
          detail_url = nil
          if tr.xpath(".//td[2]/a").first.present? 
            detail_url = "https://ja.wikipedia.org/#{tr.xpath(".//td[2]/a").first.values.first}" unless tr.xpath(".//td[2]/a").first.values.last.include?('存在しないページ')
          end
          title = tr.xpath(".//td[2]").text if title.blank?
          # 出版社
          publish = tr.xpath(".//td[3]").text
          publish = tr.xpath(".//td[2]").text if publish.blank?
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
    mounth = nil unless number?(month)
    day = nil unless number?(day)
    month + '/' + day if month.present? && day.present?
  end

  def self.number?(str)
    str.chars do | s |
      return false unless s.to_i.to_s == s.to_s
    end
    true
  end
end