class Commentators::IndexViewModel
  def initialize(commentators)
    @commentators = commentators
  end

  def to_json
    {
      commentators: fetch_commentators,
      meta: { total_count: @commentators.total_count, total_pages: @commentators.total_pages, current_page: @commentators.current_page }
    }
  end

  private

  def fetch_commentators
    @commentators.map do | commentator |
      {
        id: commentator.id,
        user_id: commentator.user_id,
        site_kbn: commentator.site_kbn,
        name: commentator.name,
        thumbnail_url: commentator.thumbnail_url
      }
    end
  end
end