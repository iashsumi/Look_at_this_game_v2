# frozen_string_literal: true

class ScThread < ApplicationRecord
  belongs_to :sc_board

  scope :great, -> { order(momentum: "DESC") }
  scope :fetched, -> { where.not(momentum: 0, is_completed: false) }
end
