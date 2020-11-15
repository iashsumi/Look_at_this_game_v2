# frozen_string_literal: true

class Articles::ShowViewModel
  def initialize(article)
    @article = article
  end

  def to_json
    {
      id: @article.id,
      title: @article.title,
      game: @article.game,
      sc_thread: @article.sc_thread,
      key_word: @article.key_word,
      thumbnail_url: @article.thumbnail_url,
      created_at: @article.created_at.strftime("%Y/%m/%d %H:%M:%S"),
      updated_at: @article.updated_at.strftime("%Y/%m/%d %H:%M:%S"),
      res_details: JSON.parse(S3.new.fetch_object("matome/#{@article.id}"))
    }
  end
end
