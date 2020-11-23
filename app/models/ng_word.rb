# frozen_string_literal: true

class NgWord < ApplicationRecord
  enum kind: {
    all: 0,
    keyword: 1
  }, _prefix: true
end
