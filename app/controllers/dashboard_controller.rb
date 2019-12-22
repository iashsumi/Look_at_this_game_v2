class DashboardController < ApplicationController
  def index
    videos = Video.order(published_at: "DESC").limit(8).page(params[:page]).per(8)
    sc_threads = ScThread.where.not(momentum: 0, is_completed: false).order(momentum: "DESC").limit(30).page(params[:page]).per(30)
    render :json => [
      Videos::IndexViewModel.new(videos).to_json,
      ScThreads::IndexViewModel.new(sc_threads).to_json
    ]
  end
end