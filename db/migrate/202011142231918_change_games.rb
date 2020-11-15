class ChangeGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :description_video_id, :string, comment: "紹介用の動画のID"
    remove_column :games, :comments, :string, comment: "ゲームへのコメントまとめ（S3のパスを保持する予定)"
    remove_column :games, :thread_name, :string, comment: "2chのスレタイ"
    remove_column :games, :thread_url, :text, comment: "2chのスレのURL"
    remove_column :games, :created_at, :datetime
    remove_column :games, :updated_at, :datetime
    add_column :games, :title_min, :string, after: :title, comment: "タイトルの省略形"
  end
end
