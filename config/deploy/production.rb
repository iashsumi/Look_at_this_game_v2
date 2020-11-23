# 環境指定
set :rails_env, "production"

# サーバー、ユーザー、ロールの指定
server Rails.application.credentials.app_host, user: "ec2-user", roles: %w{app db web}
server Rails.application.credentials.batch_host, user: "ec2-user", roles: %w{app db web}

# デプロイ先のリポジトリ指定(/home/ec2-user/test-deploy.git)
set :repo_url, "/home/ec2-user/deploy.git"

# デプロイするブランチ指定
set :branch, "master"

# SSHの設定
set :ssh_options, {
  keys: %w(./tmp/look_at_this_game.pem),
  forward_agent: false
}
