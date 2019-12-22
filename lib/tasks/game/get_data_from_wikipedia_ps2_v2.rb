require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaPs2V2 < Tasks::Game::CommonGetDataNew
  def self.get
    # PS2
    years_hash = { 2 => '2008', 3 => '2009', 4 => '2010', 5 => '2011'}
    create_data('https://ja.wikipedia.org/wiki/PlayStation_2%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [*(2..5)], Game.kinds[:ps2], nil, years_hash)
  end
end
