require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaSfc < Tasks::Game::CommonGetDataOlder
  def self.get
    # SFC
    years_hash = { 2 => '1990', 3 => '1991', 4 => '1992', 5 => '1993', 6 => '1994', 7 => '1994', 8 => '1995', 9 => '1995', 10 => '1996', 11 => '1997', 12 => '1998', 13 => '1999', 14 => '2000'}
    create_data('https://ja.wikipedia.org/wiki/%E3%82%B9%E3%83%BC%E3%83%91%E3%83%BC%E3%83%95%E3%82%A1%E3%83%9F%E3%82%B3%E3%83%B3%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7',  [*(2..14)], Game.kinds[:sfc], nil, years_hash)
  end
end
