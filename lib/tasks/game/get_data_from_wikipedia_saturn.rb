require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaSaturn < Tasks::Game::CommonGetDataOlder
  def self.get
    years_hash = { 2 => '1994', 3 => '1995', 4 => '1996', 5 => '1996', 6 => '1997', 7 => '1997', 8 => '1998', 9 => '1999', 10 => '2000'}
    create_data('https://ja.wikipedia.org/wiki/%E3%82%BB%E3%82%AC%E3%82%B5%E3%82%BF%E3%83%BC%E3%83%B3%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7',  [*(2..10)], Game.kinds[:saturn], nil, years_hash)
  end
end
