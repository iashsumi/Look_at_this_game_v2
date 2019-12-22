require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaWii < Tasks::Game::CommonGetDataNew
  def self.get
    # PS2
    years_hash = { 1 => '2006', 2 => '2007', 3 => '2008', 4 => '2009', 5 => '2010', 6 => '2011', 7 => '2012', 8 => '2013', 9 => '2014', 10 => '2015'}
    create_data('https://ja.wikipedia.org/wiki/Wii%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7#2015%E5%B9%B4%EF%BC%88%E5%85%A81%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%EF%BC%89', [*(1..10)], Game.kinds[:wii], nil, years_hash)
  end
end
