  # frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Board::Tmp.rescue_execute
class Tasks::Board::Tmp < Tasks::Base
  def self.execute
     traget = ScThread.where(is_backup: true, is_completed: false).limit(1000)
     Tasks::Board::Exec.execute(traget)
  end
end