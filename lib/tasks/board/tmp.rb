  # frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Tmp::Exec.rescue_execute
class Tasks::Tmp::Exec < Tasks::Base
  def self.execute
     traget = ScThread.where(is_backup: true, is_completed: false)
     Tasks::Board::Exec.execute(traget)
  end
end