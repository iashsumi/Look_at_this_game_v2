require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaFc < Tasks::Game::CommonGetDataOlder
  def self.get
    years_hash = { 2 => '1983', 3 => '1984', 4 => '1985', 5 => '1986', 6 => '1987', 7 => '1988', 8 => '1990', 9 => '1991', 10 => '1992', 11 => '1993', 12 => '1994'}
    create_data('https://ja.wikipedia.org/wiki/%E3%83%95%E3%82%A1%E3%83%9F%E3%83%AA%E3%83%BC%E3%82%B3%E3%83%B3%E3%83%94%E3%83%A5%E3%83%BC%E3%82%BF%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7',  [*(2..12)], Game.kinds[:fc], nil, years_hash)
  end
end
