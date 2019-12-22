require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaPsp < Tasks::Game::CommonGetDataNew
  def self.get
    # PS2
    years_hash = { 1 => '2004', 2 => '2005', 3 => '2006', 4 => '2007', 5 => '2008', 6 => '2009', 7 => '2010', 8 => '2011', 9 => '2012', 10 => '2013', 11 => '2014', 12 => '2015', 13 => '2016' }
    create_data('https://ja.wikipedia.org/wiki/PlayStation_Portable%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7',  [*(1..13)], Game.kinds[:psp], nil, years_hash)
  end
end
