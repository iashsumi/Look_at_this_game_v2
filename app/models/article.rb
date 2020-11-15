# frozen_string_literal: true

class Article < ApplicationRecord
  belongs_to :game
  belongs_to :sc_thread
end
