require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaPs4 < Tasks::Game::CommonGetDataNew
  def self.get
    years_hash = { 1 => '2014', 2 => '2015', 3 => '2016', 4 => '2017', 5 => '2018', 6 => '2019', 7 => '2020'}
    create_data('https://ja.wikipedia.org/wiki/PlayStation_4%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7#2015%E5%B9%B4%EF%BC%88%E5%85%A881%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%EF%BC%89', [*(1..7)], Game.kinds[:ps4], nil, years_hash)
  end
end
