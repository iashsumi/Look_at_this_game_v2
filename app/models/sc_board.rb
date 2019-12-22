class ScBoard < ApplicationRecord
  has_many :sc_threads, dependent: :destroy
end
