require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaGb < Tasks::Game::CommonGetDataOlder
  def self.get
    # GB
    years_hash = { 3 => '1989', 4 => '1990', 5 => '1991', 6 => '1992', 7 => '1993', 8 => '1994', 9 => '1995', 10 => '1996', 11 => '1997', 12 => '1998', 13 => '1999', 14 => '2000', 15 => '2001', 16 => '2002', 17 => '2003'}
    create_data('https://ja.wikipedia.org/wiki/%E3%82%B2%E3%83%BC%E3%83%A0%E3%83%9C%E3%83%BC%E3%82%A4%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [*(3..17)], Game.kinds[:gb], nil, years_hash)
  end
end
