# frozen_string_literal: true

class ScThreadsController < ApplicationController
  def index
    sc_threads = ScThread.fetched.great.limit(200).page(params[:page]).per(100)
    render json: ScThreads::IndexViewModel.new(sc_threads).to_json
  end

  def show
    sc_thread = ScThread.find(params[:id])
    render json: ScThreads::ShowViewModel.new(sc_thread).to_json
  end
end
