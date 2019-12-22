class Commentators::ShowViewModel
  def initialize(commentator)
    @commentator = commentator
  end

  def to_json
    {
      id: @commentator.id,
      name: @commentator.id,
      created_at: @commentator.id,
      updated_at: @commentator.id,
      channels: @commentator.channels,
      comments: @commentator.comments,
      games: @commentator.games,
      tags: @commentator.tags,
      rss_informations: @commentator.rss_informations
    }
  end
end