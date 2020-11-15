# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    articles = Article.where(is_published: true).page(params[:page])
    render json: Articles::IndexViewModel.new(articles).to_json
  end

  def show
    article = Article.find(params[:id])
    render json: Articles::ShowViewModel.new(article).to_json
  end
end
