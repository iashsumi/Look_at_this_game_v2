require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaWiiu < Tasks::Game::CommonGetDataNew
  def self.get
    # PS2
    years_hash = { 1 => '2012', 2 => '2013', 3 => '2014', 4 => '2015', 5 => '2016', 6 => '2017', 7 => '2018'}
    create_data('https://ja.wikipedia.org/wiki/Wii_U%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [*(1..7)], Game.kinds[:wiiu], nil, years_hash)
  end
end
