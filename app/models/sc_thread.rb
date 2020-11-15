# frozen_string_literal: true

class ScThread < ApplicationRecord
  belongs_to :sc_board
  belongs_to :game
  has_many :sc_thread_keywords

  scope :great, -> { order(momentum: "DESC") }
  scope :fetched, -> { where.not(momentum: 0, is_completed: false) }
  scope :range, -> (from, to) { where(thread_created_at: from..to) }
  scope :labeling, -> { where.not(label: nil) }
end
