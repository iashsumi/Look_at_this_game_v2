# docker-compose exec app bundle exec rails runner Tasks::Game::Exec.execute
class Tasks::Game::Exec
  def self.execute
    Rails.logger.debug('Start')
    Rails.logger.debug(Time.now)
    # # ファミリーコンピュータのゲームタイトル一覧
    # p 'ファミリーコンピュータのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaFc.get
    # rescue => exception
    #   p exception.message
    # end
    # # # ディスクシステムのゲームタイトル一覧
    # # # TODO?
    # # # スーパーファミコンのゲームタイトル一覧
    # p 'スーパーファミコンのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaSfc.get
    # rescue => exception
    #   p exception.message
    # end
    # # # バーチャルボーイのゲームタイトル一覧
    # # # TODO?
    # # # NINTENDO64のゲームタイトル一覧
    # p 'NINTENDO64のゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaN64.get
    # rescue => exception
    #   p exception.message
    # end
    # # # ニンテンドーゲームキューブのゲームタイトル一覧
    # p 'ニンテンドーゲームキューブのゲームタイトル一覧'
    # begin
    #  Tasks::Game::GetDataFromWikipediaGc.get
    # rescue => exception
    #   p exception.message
    # end
    # # # Wiiのゲームタイトル一覧
    # p 'Wiiのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaWii.get
    # rescue => exception
    #   p exception.message
    # end
    # # # Wii Uのゲームタイトル一覧
    # p 'Wii Uのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaWiiu.get
    # rescue => exception
    #   p exception.message
    # end
    # # Nintendo Switchのゲームタイトル一覧
    p 'Nintendo Switchのゲームタイトル一覧'
    begin
      Tasks::Game::GetDataFromWikipediaSwitch.get
    rescue => exception
      p exception.message
    end
    #   # # ゲームボーイのゲームタイトル一覧
    # p 'ゲームボーイのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaGb.get
    # rescue => exception
    #   p exception.message
    # end
    # # # ゲームボーイアドバンスのゲームタイトル一覧
    # p 'ゲームボーイアドバンスのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaGba.get
    # rescue => exception
    #   p exception.message
    # end
    # # # ニンテンドーDSのゲームタイトル一覧
    # p 'ニンテンドーDSのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaDs.get
    # rescue => exception
    #   p exception.message
    # end
    # # ニンテンドー3DSのゲームタイトル一覧
    p 'ニンテンドー3DSのゲームタイトル一覧'
    begin
      Tasks::Game::GetDataFromWikipediaDs3.get
    rescue => exception
      p exception.message
    end
    # # # ニンテンドウパワーのゲームタイトル一覧
    # # # TODO?
    # # # バーチャルコンソールのゲームタイトル一覧
    # # # TODO?
    # # # PlayStationのゲームタイトル一覧
    # p 'PlayStationのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaPs.get
    # rescue => exception
    #   p exception.message
    # end
    # # # PlayStation 2のゲームタイトル一覧
    # p 'PlayStation 2のゲームタイトル一覧-1'
    # begin
    #   Tasks::Game::GetDataFromWikipediaPs2V1.get
    # rescue => exception
    #   p exception.message
    # end
    # p 'PlayStation 2のゲームタイトル一覧-2'
    # begin 
    #   Tasks::Game::GetDataFromWikipediaPs2V2.get
    # rescue => exception
    #   p exception.message
    # end
    # # # PlayStation 3のゲームタイトル一覧
    # p 'PlayStation 3のゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaPs3.get
    # rescue => exception
    #   p exception.message
    # end
    # # PlayStation 4のゲームタイトル一覧
    p 'PlayStation 4のゲームタイトル一覧'
    begin
      Tasks::Game::GetDataFromWikipediaPs4.get
    rescue => exception
      p exception.message
    end
    # # # PlayStation Portableのゲームタイトル一覧
    # p 'PlayStation Portableのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaPsp.get
    # rescue => exception
    #   p exception.message
    # end
    # # PlayStation Vitaのゲームタイトル一覧
    p 'PlayStation Vitaのゲームタイトル一覧'
    begin
      Tasks::Game::GetDataFromWikipediaPsv.get
    rescue => exception
      p exception.message
    end
    # # Xboxのゲームタイトル一覧
    # p 'Xboxのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaXbox.get
    # rescue => exception
    #   p exception.message
    # end
    # # Xbox 360のゲームタイトル一覧
    # p 'Xbox 360のゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaXboxSanrokumaru.get
    # rescue => exception
    #   p exception.message
    # end
    # # Xbox Oneのゲームタイトル一覧
    # p 'Xbox Oneのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaXboxOne.get
    # rescue => exception
    #   p exception.message
    # end
    # # セガサターンのゲームタイトル一覧
    # p 'セガサターンのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaSaturn.get
    # rescue => exception
    #   p exception.message
    # end
    # # ドリームキャストのゲームタイトル一覧
    # p 'ドリームキャストのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaDream.get
    # rescue => exception
    #   p exception.message
    # end
    # # ワンダースワンのゲームタイトル一覧
    # p 'ワンダースワンのゲームタイトル一覧'
    # begin
    #   Tasks::Game::GetDataFromWikipediaSwan.get
    # rescue => exception
    #   p exception.message
    # end
    Rails.logger.debug(Time.now)
    Rails.logger.debug('End')
  end
end
