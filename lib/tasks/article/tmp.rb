# frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Board::Tmp.rescue_execute
class Tasks::Article::Tmp < Tasks::Base
  def self.execute
    limit = Configuration.all.first.value.to_i
    target = ScThreadKeyword.eager_load(:sc_thread).merge(ScThread.labeling).merge(ScThread.where(is_completed: true, is_backup: true).where.not(id: Article.all.pluck(:sc_thread_id).uniq)).limit(limit)
    Tasks::Article::Create.execute(nil, nil, target)
  end
end