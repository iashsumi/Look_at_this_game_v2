# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    videos = Video.recent.limit(8).page(params[:page]).per(16)
    sc_threads = ScThread.fetched.great.limit(30).page(params[:page]).per(16)
    res_video = Videos::IndexViewModel.new(videos).to_json
    res_thread = ScThreads::IndexViewModel.new(sc_threads).to_json
    render json: [res_video, res_thread]
  end
end
