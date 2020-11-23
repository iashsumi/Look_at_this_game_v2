# frozen_string_literal: true

require "open-uri"
require "nokogiri"
require "json"
require 'natto'

class Tasks::Article::Service
  def fetch_data(url, dat = nil)
    @meisi = []
    @do = []
    dat = dat.blank? ? Function.fetch_html(url) : dat
    return if dat.blank?

    # ex."名前は開発中のものです<><>2018/05/04(金) 20:34:21.06 ID:1cp7WNOG.net<> アクションとFPSが好き、あとPC移るからPCゲーでもいい <>PS4やることないからおすすめ教えて\n
    data = []
    dat.split(/\r\n|\r|\n/).each_with_index do |item, index|
      # １文を見ると<>が区切りになっているので再度分割.その後抽出
      values = item.split(/\<\>/)
      break if values.blank?

      data << parse_dat(index, values)
    end
    # レス抽出
    reply = fetch_reply(data)
    # まとめ作成
    tmp = build_matome(data, reply)
    tmp.each do | i |
      # 1番目は除外
      next if i[:no] == 1

      m, d = analyze(i[:text])
      i[:m_tags] = m
      i[:children].each do | j |
        m, d = analyze(j[:text])
        j[:m_tags] = m
      end
    end
    meta = {
      m_tag_all: @meisi.group_by(&:itself).map {|k, v| [k, v.size] }.sort_by{ |_, v| -v }
    }

    result = []
    # フィルター作成(閾値は10でNGワードを含んでいないもの)
    filter = meta[:m_tag_all].select{|i| i[1] >= 10 && !(NgWord.kind_all.pluck(:word).include?(i[0])) }.map{|i| i.first }
    tmp.each do | i |
      # 1番目は除外
      next if i[:no] == 1

      start = result.length
      # 親チェック
      i[:m_tags].each do | j |
        result << i if filter.include?(j)
      end
      next if result.length > start 
      
      # 子供チェック
      i[:children].each do | j |
        result << i if j[:m_tags].any? {| k | filter.include?(k) }
        break if result.length > start 
      end
    end
    [result.uniq, meta]
  end

  private
    def parse_dat(index, values)
      no = index + 1
      title = values[4] if values.size == 5
      name = values[0]
      # 秒以下まで含むと秒以下がない日付が落ちるので秒まで取得
      date = values[2].match(%r@\d{4}/\d{2}/\d{2}\(.\) \d{2}\:\d{2}:\d{2}@m)
      id = values[2].match(/ID\:.+/m)
      text = values[3]
      # 画像を含む場合は抽出
      images = []
      # jpg, png, bmp, gifを取得
      # scanだと()を含むと()の部分にマッチした文字列の配列の配列を返すので下記の書き方でやる
      values[3].scan(%r{https?://[\w_.!*\/')(-]+\.jpg|https?://[\w_.!*\/')(-]+\.png|https?://[\w_.!*\/')(-]+\.bmp|https?://[\w_.!*\/')(-]+\.gif}).to_a.each do |image|
        # httpsじゃない場合、httpsに置き換え
        image.delete_prefix("http").prepend("https") unless image[0..4] == "https"
        images << image
      end
      text_temp = ActionController::Base.helpers.strip_tags(text)
      res_no = text_temp.match(/&gt;&gt;[0-9]*/).blank? ? nil : text_temp.match(/&gt;&gt;[0-9]*/)[0].gsub('&gt;&gt;', '').to_i
      { title: title, no: no, res_no: res_no, name: name, date: date, id: id, text: text, images: images }
    end

    # レスを抽出
    def fetch_reply(data)
      reply = []
      data.each do |item|
        ele = Nokogiri::HTML.parse(item[:text], nil, "CP932")
        ele.search("a").each do |node|
          # ">>101"この状態なので、不要な部分を削除して、Intに変換
          res_no = node.children.text.delete(">>").to_i
          # 自分自身へのレスがあったら追加しない
          next if res_no == item[:no]
          # 循環参照になりうるレスは追加しない(自分の投稿よりあとへのレスもある)
          next if res_no > item[:no]
          # 1へのレスは追加しない
          next if res_no == 1

          reply << { no: item[:no], parent_no: res_no, item: item }
        end
      end
      reply
    end

    def build_matome(data, reply)
      target = []
      data.each do |item|
        next if item[:res_no].present?

        # 1件目は必ず入れる
        target << item if item[:no] == 1
        res = reply.select { |i| i[:parent_no] == item[:no] }
        next if res.blank?

        # 最初に入れているので除外 || すでに同じ項目がある場合は除外(子に対するレスなど)
        next if item[:no] == 1 || target.find { |i| i[:no] == item[:no] }.present?

        children = []
        res.each do |i|
          # レスに対するレスを取得
          fetch_res_loop(i, reply).each do |j|
            children << j[:item]
          end
        end
        children.uniq!
        children.sort_by! { |a| a[:no] }
        item[:children] = children
        target << item
      end
      target.uniq
    end

    # レスを順番に取得
    def fetch_res_loop(child, reply)
      return [] if child.blank?

      result = [child]
      target = [child]
      loop do
        a = []
        break if target.flatten.blank?

        target.each do |i|
          a << reply.select { |j| j[:parent_no] == i[:no] }
          break if a.blank?

          parent_index = result.index { |v| v[:no] == i[:no] }
          result.insert(parent_index + 1, a)
          result.flatten!
        end
        target = a.flatten
      end
      result.flatten
    end

    def analyze(str)
      nm = Natto::MeCab.new
      # <<XXXを削除
      target = ActionController::Base.helpers.strip_tags(str).gsub(/&gt;&gt;[0-9]*/, '')
      # URLを除去
      URI.extract(target).uniq.each {|url| target.gsub!(url, '')}
      hukugo = []
      value1 = []
      value2 = []
      nm.parse(target) do | n |
        if n.feature.split(",").first == '名詞' && (n.feature.split(",")[1] == '固有名詞' || n.feature.split(",")[1] == '一般')
          # １文字除外
          next if n.surface.length == 1
          # 名刺が続けば連結
          hukugo << n.surface
        else
          @meisi << hukugo.join unless hukugo.blank?
          value1 << hukugo.join unless hukugo.blank?
          # 名刺以外の場合は初期化
          hukugo = []
        end
        if ['動詞', '助詞', '助動詞'].include?(n.feature.split(",").first)
          @do << n.surface
          value2 << n.surface
        end
      end
      [value1.uniq, value2.uniq]
    end
end
