# frozen_string_literal: true

class GameCommentator < ApplicationRecord
  belongs_to :commentator
  belongs_to :game
end
