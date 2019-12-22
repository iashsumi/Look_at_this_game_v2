class Init < ActiveRecord::Migration[5.2]
  def change
    create_table :commentators do |t|
      t.integer :site_kbn, limit: 1, null: false, comment: "動画のサイトのenum"
      t.string :user_id, null: false, comment: "動画のサイト上のユーザーID"
      t.string :name, null: false
      t.string :thumbnail_url, null: false
      t.timestamps
    end
    
    create_table :videos do |t|
      t.references :commentator
      t.string :content_id, null: false
      t.string :title, null: false
      t.string :link, null: false, comment: "動画のURL"
      t.text :description, null: false
      t.string :thumbnail_url, null: false
      t.datetime :published_at, null: false, comment: "公開日"
      t.bigint :view_count, null: false, comment: "再生回数"
      t.string :momentum, comment: "勢い"
      t.timestamps
    end

    create_table :games do |t|
      t.string :title, comment: "ゲームタイトル"
      t.integer :kind, comment: "機種"
      t.datetime :release_date_at, comment: "発売日"
      t.string :publisher, comment: "販売元"
      t.text :description, comment: "説明"
      t.string :description_video_id, comment: "紹介用の動画のID"
      t.string :thumbnail, comment: "ゲームのサムネ"
      t.string :comments, comment: "ゲームへのコメントまとめ（S3のパスを保持する予定)"
      t.string :thread_name, comment: "2chのスレタイ"
      t.text :thread_url, comment: "2chのスレのURL"
      t.timestamps
    end

    create_table :genres do |t|
      t.string :name
      t.timestamps
    end

    create_table :game_commentators do |t|
      t.references :game
      t.references :commentator
      t.timestamps
    end

    create_table :sc_boards do |t|
      t.string :title
      t.text :threads_url, comment: "スレッド一覧のURL"
      t.text :domain
      t.timestamps
    end

    # 勢い = レス数 / (現在のUNIX時間 - スレッド内の1番目の投稿のUNIX時間) ÷ 86400。
    create_table :sc_threads do |t|
      t.references :sc_board
      t.string :title
      t.text :url
      t.datetime :thread_created_at, comment: "スレッド内の1番目の投稿の時間"
      t.integer :res, comment: "レスの数"
      t.integer :momentum, comment: "勢い"
      t.boolean :is_completed, comment: "スレのデータを取得ずみかどうか(trueのデータのみフロントに返す)"
      t.timestamps
    end
  end
end
