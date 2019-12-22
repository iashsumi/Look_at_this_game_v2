require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaPs3 < Tasks::Game::CommonGetDataNew
  def self.get
    # PS2
    years_hash = { 1 => '2006', 2 => '2007', 3 => '2008', 4 => '2009', 5 => '2010', 6 => '2011', 7 => '2012', 8 => '2013', 9 => '2014', 10 => '2015', 11 => '2016', 12 => '2017', 13 => '2018'}
    create_data('https://ja.wikipedia.org/wiki/PlayStation_3%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [*(1..13)], Game.kinds[:ps3], nil, years_hash)
  end
end
