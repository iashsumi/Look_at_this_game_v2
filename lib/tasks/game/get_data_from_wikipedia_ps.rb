require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaPs < Tasks::Game::CommonGetDataOlder
  def self.get
    # PS
    years_hash = { 1 => '1994', 2 => '1995', 3 => '1995'}
    create_data('https://ja.wikipedia.org/wiki/PlayStation%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(-1995%E5%B9%B4)', [1,2,3], Game.kinds[:ps], nil, years_hash)
    #1996
    create_data('https://ja.wikipedia.org/wiki/PlayStation%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(1996%E5%B9%B4)', [*(1..13)], Game.kinds[:ps], '1996')
    #1997
    create_data('https://ja.wikipedia.org/wiki/PlayStation%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(1997%E5%B9%B4)', [*(1..12)], Game.kinds[:ps], '1997')
    #1998
    create_data('https://ja.wikipedia.org/wiki/PlayStation%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(1998%E5%B9%B4)', [*(1..12)], Game.kinds[:ps], '1998')
    #1999
    create_data('https://ja.wikipedia.org/wiki/PlayStation%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(1999%E5%B9%B4)', [*(1..12)], Game.kinds[:ps], '1999')
    #2000
    create_data('https://ja.wikipedia.org/wiki/PlayStation%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(2000%E5%B9%B4)', [*(1..13)], Game.kinds[:ps], '2000')
    #2001
    create_data('https://ja.wikipedia.org/wiki/PlayStation%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(2001%E5%B9%B4)', [*(1..12)], Game.kinds[:ps], '2001')
    #2002
    create_data('https://ja.wikipedia.org/wiki/PlayStation%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(2002%E5%B9%B4)', [*(1..12)], Game.kinds[:ps], '2002')
    #2003
    create_data('https://ja.wikipedia.org/wiki/PlayStation%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(2003%E5%B9%B4-)', [*(1..2)], Game.kinds[:ps], nil, { 1 => '2003', 2 => '2004' })
  end
end
