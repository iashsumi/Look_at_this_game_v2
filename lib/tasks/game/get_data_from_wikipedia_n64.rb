require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaN64 < Tasks::Game::CommonGetDataOlder
  def self.get
    # N64
    years_hash = { 1 => '1996', 2 => '1997', 3 => '1998', 4 => '1999', 5 => '2000', 6 => '2001'}
    create_data('https://ja.wikipedia.org/wiki/NINTENDO64%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [*(1..6)], Game.kinds[:n64], nil, years_hash)
  end
end
