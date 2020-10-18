# frozen_string_literal: true

class CommentatorsController < ApplicationController
  def index
    commentators = Commentator.page(params[:page])
    render json: Commentators::IndexViewModel.new(commentators).to_json
  end
end
