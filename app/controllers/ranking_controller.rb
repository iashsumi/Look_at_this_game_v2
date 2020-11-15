# frozen_string_literal: true

class RankingController < ApplicationController
  def index
    # 当日
    from = DateTime.current.beginning_of_day
    to = DateTime.current.end_of_day
    # 前日
    prev_from = DateTime.current.prev_day(1).beginning_of_day
    prev_to = DateTime.current.prev_day(1).end_of_day
    today_summary = ScThread.ranking(from, to)
    prev_summary = ScThread.ranking(prev_from, prev_to)
    render json: Ranking::IndexViewModel.new(today_summary, prev_summary).to_json
  end
end
