class Video < ApplicationRecord
  belongs_to :commentator
  has_many :video_views, dependent: :destroy
end
