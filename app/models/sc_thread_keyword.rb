# frozen_string_literal: true

class ScThreadKeyword < ApplicationRecord
  belongs_to :sc_thread

  # 閾値(まとめサイト用)
  scope :threshold_1, -> { where('appearances >= 20') }
end
