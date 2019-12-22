require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaDs3 < Tasks::Game::CommonGetDataNew
  def self.get
    years_hash = { 1 => '2011', 2 => '2012', 3 => '2013', 4 => '2014', 5 => '2015', 6 => '2016', 7 => '2017', 8 => '2018', 9 => '2019'}
    create_data('https://ja.wikipedia.org/wiki/%E3%83%8B%E3%83%B3%E3%83%86%E3%83%B3%E3%83%89%E3%83%BC3DS%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [*(1..9)], Game.kinds[:ds3], nil, years_hash)
  end
end
