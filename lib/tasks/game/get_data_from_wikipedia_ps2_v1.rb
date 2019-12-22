require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaPs2V1 < Tasks::Game::CommonGetDataOlder
  def self.get
    # PS2
    years_hash = { 1 => '2000', 2 => '2000', 3 => '2001', 4 => '2001'}
    create_data('https://ja.wikipedia.org/wiki/PlayStation_2%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(2000%E5%B9%B4-2001%E5%B9%B4)', [1,2,3,4], Game.kinds[:ps2], nil, years_hash)
    #2002
    create_data('https://ja.wikipedia.org/wiki/PlayStation_2%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(2002%E5%B9%B4)', [*(1..12)], Game.kinds[:ps2], '2002')
    #2003
    create_data('https://ja.wikipedia.org/wiki/PlayStation_2%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(2003%E5%B9%B4)', [*(1..12)], Game.kinds[:ps2], '2003')
    #2004
    create_data('https://ja.wikipedia.org/wiki/PlayStation_2%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(2004%E5%B9%B4)', [*(1..12)], Game.kinds[:ps2], '2004')
    #2005
    create_data('https://ja.wikipedia.org/wiki/PlayStation_2%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(2005%E5%B9%B4)', [*(1..12)], Game.kinds[:ps2], '2005')
    #2006
    create_data('https://ja.wikipedia.org/wiki/PlayStation_2%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(2006%E5%B9%B4)', [*(1..12)], Game.kinds[:ps2], '2006')
    #2007
    create_data('https://ja.wikipedia.org/wiki/PlayStation_2%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7_(2007%E5%B9%B4)', [*(1..4)], Game.kinds[:ps2], '2007')
    #2008年前半
    create_data('https://ja.wikipedia.org/wiki/PlayStation_2%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [2], Game.kinds[:ps2], '2008')
  end
end
