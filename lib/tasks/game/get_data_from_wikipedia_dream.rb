require 'open-uri' # URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' # Nokogiriライブラリを読み込みます。

class Tasks::Game::GetDataFromWikipediaDream < Tasks::Game::CommonGetDataOlder
  def self.get
    years_hash = { 2 => '1998', 3 => '1999', 4 => '1999', 5 => '2000', 6 => '2000', 7 => '2001', 8 => '2001', 9 => '2002', 10 => '2003', 11 => '2004', 12 => '2005', 13 => '2006', 14 => '2007'}
    create_data('https://ja.wikipedia.org/wiki/%E3%83%89%E3%83%AA%E3%83%BC%E3%83%A0%E3%82%AD%E3%83%A3%E3%82%B9%E3%83%88%E3%81%AE%E3%82%B2%E3%83%BC%E3%83%A0%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E4%B8%80%E8%A6%A7',  [*(2..14)], Game.kinds[:dream], nil, years_hash)
  end
end
