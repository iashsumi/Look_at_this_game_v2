# frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Board::Tmp.rescue_execute
class Tasks::Article::Tmp < Tasks::Base
  def self.execute
     traget = ScThreadKeyword.eager_load(:sc_thread).merge(ScThread.labeling).merge(ScThread.where(is_completed: true, is_backup: true)).limit(400)
     Tasks::Article::Create.execute(nil, nil, target)
  end
end