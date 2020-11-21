# frozen_string_literal: true

# docker-compose exec app bundle exec rails runner Tasks::Board::Backup.rescue_execute
class Tasks::Board::Backup < Tasks::Base
  def self.execute(target = nil)
    client = S3.new
    complete = []
    if target.blank?
      target = ScThread.where('res >= 1001').where(is_backup: false)
    end
    target.find_each do | thread |
      dat = Function.fetch_html(thread.url)
      next if dat.blank?

      client.put_object("backup/#{thread.id}", dat)
      thread.is_backup = true
      complete << thread
    end
    ScThread.import(complete, on_duplicate_key_update: [:is_backup])
  end
end