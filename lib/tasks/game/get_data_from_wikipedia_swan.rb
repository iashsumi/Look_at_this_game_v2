require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaSwan < Tasks::Game::CommonGetDataOlder
  def self.get
    years_hash = { 2 => '1999', 3 => '2000', 4 => '2001', 5 => '2002', 6 => '2003', 7 => '2004'}
    create_data('https://ja.wikipedia.org/wiki/%E3%83%AF%E3%83%B3%E3%83%80%E3%83%BC%E3%82%B9%E3%83%AF%E3%83%B3%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7',  [*(2..7)], Game.kinds[:swan], nil, years_hash)
  end
end
