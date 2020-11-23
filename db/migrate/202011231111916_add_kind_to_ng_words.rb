class AddKindToNgWords < ActiveRecord::Migration[5.2]
  def change
    add_column :ng_words, :kind, :integer
  end
end
