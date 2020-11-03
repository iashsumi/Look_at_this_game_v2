class CreateScThreadKeywords < ActiveRecord::Migration[5.2]
  def change
    create_table :sc_thread_keywords do |t|
      t.references :sc_thread
      t.string :word, comment: "キーワード"
      t.integer :appearances, comment: "キーワードの出現回数"
      t.boolean :is_used, comment: "キーワードを使用するかどうか"
      t.timestamps
    end
  end
end
