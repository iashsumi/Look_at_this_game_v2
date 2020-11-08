class CreateNgWords < ActiveRecord::Migration[5.2]
  def change
    create_table :ng_words do |t|
      t.string :word, comment: "NGワード"
      t.timestamps
    end
  end
end
