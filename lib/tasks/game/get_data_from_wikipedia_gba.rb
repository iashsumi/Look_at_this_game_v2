require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaGba < Tasks::Game::CommonGetDataOlder
  def self.get
    # GBA
    years_hash = { 1 => '2001', 2 => '2001', 3 => '2002', 4 => '2002', 5 => '2003', 6 => '2003', 7 => '2004', 8 => '2004', 9 => '2005', 10 => '2006'}
    create_data('https://ja.wikipedia.org/wiki/%E3%82%B2%E3%83%BC%E3%83%A0%E3%83%9C%E3%83%BC%E3%82%A4%E3%82%A2%E3%83%89%E3%83%90%E3%83%B3%E3%82%B9%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [*(1..10)], Game.kinds[:gba], nil, years_hash)
  end
end
