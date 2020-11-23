# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# MEMO
# cron への反映
# $ bundle exec whenever --update-crontab
# cron へ反映した内容の確認（どちらの行でも確認できる）
# $ bundle exec whenever
# $ bundle exec crontab -e
# cron へ反映した内容を削除
# $ bundle exec whenever --clear-crontab

set :output, "log/crontab.log"
set :runner_command, "rails runner"


every 1.hours do
  runner "Tasks::Board::Exec.rescue_execute"
end

every 1.hours do
  runner "Tasks::Board::Backup.rescue_execute"
end

# まとめ情報作成
every 1.hours do
  runner "Tasks::Article::Tmp.rescue_execute"
end

# YouTube RSS
every 30.minute do
  runner "Tasks::Rss::Youtube.rescue_execute"
end

# NicoNico RSS
every 30.minute do
  runner "Tasks::Rss::Niconico.rescue_execute"
end
