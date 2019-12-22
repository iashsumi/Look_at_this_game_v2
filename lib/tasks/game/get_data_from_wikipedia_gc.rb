require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaGc < Tasks::Game::CommonGetDataOlder
  def self.get
    # GC
    years_hash = { 1 => '2001', 2 => '2002', 3 => '2003', 4 => '2004', 5 => '2005', 6 => '2006'}
    create_data('https://ja.wikipedia.org/wiki/%E3%83%8B%E3%83%B3%E3%83%86%E3%83%B3%E3%83%89%E3%83%BC%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%AD%E3%83%A5%E3%83%BC%E3%83%96%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7', [*(1..6)], Game.kinds[:gc], nil, years_hash)
  end
end
