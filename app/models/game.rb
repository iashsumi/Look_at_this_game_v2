class Game < ApplicationRecord
  has_many :game_commentators
  has_many :commentators, through: :game_commentators

  enum kind: { 
    fc: 0, 
    sfc: 1, 
    gb: 2, 
    gba: 3, 
    n64: 4, 
    gc: 5, 
    ds: 6, 
    ps: 7, 
    ps2: 8, 
    ps3: 9, 
    ps4: 10, 
    ds3: 11, 
    wii: 12, 
    wiiu: 13, 
    switch:14, 
    psp: 15, 
    psv: 16,
    xbox: 17,
    xbox_360: 18,
    xbox_one: 19,
    saturn: 20,
    dream: 21,
    swan: 22
  }

  def insert
    # 同タイトルのゲームは登録しない
    return if Game.find_by(title: title, kind: kind).present?
    save
  end
end
