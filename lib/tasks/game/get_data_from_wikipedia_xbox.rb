require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaXbox < Tasks::Game::CommonGetDataNew
  def self.get
    years_hash = { 1 => '2003', 2 => '2004', 3 => '2005', 4 => '2006', 5 => '2007'}
    create_data('https://ja.wikipedia.org/wiki/Xbox%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [*(1..5)], Game.kinds[:xbox], nil, years_hash)
  end
end
