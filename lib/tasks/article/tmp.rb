# frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Board::Tmp.rescue_execute
class Tasks::Article::Tmp < Tasks::Base
  def self.execute
      target = ScThreadKeyword.eager_load(:sc_thread).merge(ScThread.labeling).merge(ScThread.where(is_completed: true, is_backup: true))
      Tasks::Article::Create.execute(nil, nil, target)
  end
end