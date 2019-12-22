require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaXboxSanrokumaru < Tasks::Game::CommonGetDataNew
  def self.get
    years_hash = { 1 => '2005', 2 => '2006', 3 => '2007', 4 => '2008', 5 => '2009', 6 => '2010', 7 => '2011', 8 => '2012', 9 => '2013', 10 => '2014', 11 => '2015'}
    create_data('https://ja.wikipedia.org/wiki/Xbox%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [*(1..11)], Game.kinds[:xbox_360], nil, years_hash)
  end
end
