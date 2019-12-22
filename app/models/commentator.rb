class Commentator < ApplicationRecord
  has_many :videos, dependent: :destroy
  has_many :game_commentators
  has_many :games, through: :game_commentators

  enum site_kbn: [ :youtube, :niconico ]
end
