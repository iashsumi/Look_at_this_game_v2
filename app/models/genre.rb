# frozen_string_literal: true

class Genre < ApplicationRecord
  belongs_to :video_views
end
