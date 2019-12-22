class CommentatorsController < ApplicationController
  def index
    commentators = Commentator.page(params[:page])
    render :json => Commentators::IndexViewModel.new(commentators).to_json
  end

  # def show
  #   commentator = Commentator.find(params[:id])
  #   render :json => { commentator: Commentators::ShowViewModel.new(commentator).to_json }
  # end
end