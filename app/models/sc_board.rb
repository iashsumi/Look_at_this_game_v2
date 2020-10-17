# frozen_string_literal: true

class ScBoard < ApplicationRecord
  has_many :sc_threads, dependent: :destroy
end
