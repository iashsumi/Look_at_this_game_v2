require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaSwitch < Tasks::Game::CommonGetDataNew
  def self.get
    years_hash = { 1 => '2017', 2 => '2018', 3 => '2019', 4 => '2020' }
    create_data('https://ja.wikipedia.org/wiki/Nintendo_Switch%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [1,2,3,4], Game.kinds[:switch], nil, years_hash)
  end
end
