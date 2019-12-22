# docker-compose exec app bundle exec rails runner Tasks::Board::Exec.rescue_execute
require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。
require 'json'

class Tasks::Board::Exec < Tasks::Base
  def self.execute
    notifier = Slack::Notifier.new(Rails.application.credentials.slack_url, channel: '#notification')
    notifier.ping('Start Tasks::Board::Exec')
    client = S3.new
    # スレ更新
    fetch_board

    # 各板の勢いの強い順に並び替え、TOP200に対してスクレピングしてコメをまとめる(勢いが0のものは取得しない)
    ScThread.where.not(momentum: 0).order(momentum: "DESC").limit(200).each do | item |
      # url = 'http://awabi.2ch.sc/gamenews/dat/1525433661.dat'
      fetched_data = fetch_thread(item.url)
      next if fetched_data.blank?
      
      # S3 UPLOAD
      client.put_object(item.id.to_s, JSON.dump(fetched_data))
      # データを取得したらフラグ更新
      item.update(is_completed: true)
      # 取得の間隔制御
      sleep 3
    end
    notifier.ping('End Tasks::Board::Exec')
  end

  def self.fetch_board
    ScBoard.all.each do | board |
      doc = fetch_html(board.threads_url)
      next if doc.blank?
      doc.split(/\r\n|\r|\n/).each_with_index do | item, i |
        begin
          ele = Nokogiri::HTML.parse(item)
          # <a>タグを検索
          ele.search('a').each do |node|
            thread_created_at = 0
            begin
              # 1596038088/l50 前半ユニックスタイムスタンプ=スレ立った時間
              # 変換できないケースもあるのでエラー処理する
              thread_created_at = node.attributes["href"].value.match(%r@\d*@m)[0].to_i
            rescue => e
              ExceptionNotifier.notify_exception(e, :env => Rails.env, :data => {:message => board.title})
              next
            end
            
            # undefined method '+' for nil:NilClassが多いのでチェック
            next if node.children.text.index(":").blank?
            next if node.children.text.rindex("(").blank?
            
            # スレタイ 791: ★psハード買おうと思ってるんだけど (3)
            start_index = node.children.text.index(":").to_i + 2
            end_index = node.children.text.rindex("(").to_i - 1

            # 星付きは除去して表示
            title = node.children.text[start_index ... end_index][0] == '★' ? node.children.text[(start_index + 1) ... end_index] : node.children.text[start_index ... end_index]
            # スレNo XXXの形式で取得
            # node.children.text.match(%r@\d{1,4}@m)
            # レス数 (XXX)の形式で取得
            res = node.children.text.match(%r@\(\d{1,4}\)@m)[0]
            res_i = res.slice(1, (res.length - 1)).to_i
            url = "#{board.domain}dat/#{thread_created_at.to_s}.dat"
            momentum = nil
            # レス数が２０以下の場合は0
            if res_i <= 20
              momentum = 0
            else
              # レス数 / (現在のUNIX時間 - スレッド内の1番目の投稿のUNIX時間) ÷ 86400
              num = (Time.now.to_i - thread_created_at) / 86400
              momentum = (num.zero? || num < 0) ? 0 : res_i / num
            end
            thread = ScThread.where(sc_board: board, url: url).first
            if thread.present?
              thread.res = res_i
              thread.momentum = momentum
              thread.save!
            else
              ScThread.create(sc_board: board, title: title, url: url, thread_created_at: Time.at(thread_created_at), res: res_i, momentum: momentum, is_completed: false)
            end
          end
        rescue => e
          ExceptionNotifier.notify_exception(e, :env => Rails.env, :data => {:message => board.title})
          next
        end
      end
    end
  end
  
  def self.fetch_thread(url)
    dat = fetch_html(url)
    return if dat.blank?

    # ex."名前は開発中のものです<><>2018/05/04(金) 20:34:21.06 ID:1cp7WNOG.net<> アクションとFPSが好き、あとPC移るからPCゲーでもいい <>PS4やることないからおすすめ教えて\n
    data = []
    dat.split(/\r\n|\r|\n/).each_with_index do | item, i |
      # １文を見ると<>が区切りになっているので再度分割.その後抽出
      values = item.split(/\<\>/)
      return if values.blank?
      no = i + 1
      title = values[4] if values.size == 5
      name = values[0]
      # 秒以下まで含むと秒以下がない日付が落ちるので秒まで取得
      date = values[2].match(%r@\d{4}/\d{2}/\d{2}\(.\) \d{2}\:\d{2}:\d{2}@m)
      id = values[2].match(%r@ID\:.+@m)
      text = values[3]
      data << { title: title, no: no, name: name, date: date, id: id, text: text }
    end

    # レス抽出
    filter = []
    data.each do | item |
      ele = Nokogiri::HTML.parse(item[:text], nil, 'CP932')
      # <a>タグを検索
      ele.search('a').each do |node|
        # ">>101"この状態なので、不要な部分を削除して、Intに変換
        res_no = node.children.text.delete(">>").to_i
        filter << { res_no: res_no, item: item }
      end
    end

    # レス付きのみ抽出
    target = []
    data.each do | item |
      # 1件目は必ず入れる
      target << item if item[:no] == 1
      res = filter.find{ |i| i[:res_no] == item[:no] }
      next if res.blank?
      # 最初に入れているので除外 || すでに同じ項目がある場合は除外(子に対するレスなど)
      target << item unless item[:no] == 1 || target.find{ |i| i[:no] == item[:no] }.present?
      # レスのデータは目印をつける
      res[:item].store(:child, true)
      target << res[:item]
    end
    target
  end

  def self.fetch_html(url)
    open(url, 'r:binary') do |f|
      f.read.encode("utf-8", "cp932", invalid: :replace, undef: :replace)
    end
  rescue => e
    ExceptionNotifier.notify_exception(e, :env => Rails.env, :data => {:message => url})
    nil
  end
end