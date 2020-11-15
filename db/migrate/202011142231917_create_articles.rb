class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.references :game
      t.references :sc_thread
      t.string :key_word, comment: "この記事を作る元となったキーワード"
      t.string :thumbnail_url, comment: "サムネ"
      t.text :comments, comment: "親コメント一覧"
      t.text :image_paths, comment: "画像パス一覧"
      t.boolean :is_published, default: false, comment: "公開するかどうか"
      t.timestamps
    end
  end
end
