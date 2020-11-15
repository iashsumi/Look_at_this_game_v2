# frozen_string_literal: true

class Articles::IndexViewModel
  def initialize(articles)
    @articles = articles
  end

  def to_json(*_args)
    {
      articles: fetch_articles,
      meta: {
        total_count: @articles.total_count,
        total_pages: @articles.total_pages,
        current_page: @articles.current_page
      }
    }
  end

  private
    def fetch_articles
      @articles.includes(:game, :sc_thread).map do |article|
        {
          id: article.id,
          title: article.title,
          game: article.game,
          sc_thread: article.sc_thread,
          key_word: article.key_word,
          thumbnail_url: article.thumbnail_url,
          created_at: article.created_at.strftime("%Y/%m/%d %H:%M:%S"),
          updated_at: article.updated_at.strftime("%Y/%m/%d %H:%M:%S"),
        }
      end
    end
end
