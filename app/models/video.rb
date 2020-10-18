# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :commentator
  has_many :video_views, dependent: :destroy

  scope :recent, -> { order(published_at: "DESC") }
end
