class AddIsCheckToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :is_check, :boolean, after: :is_published, default: false, comment: "自分で内容をチェックしたかどうか"
  end
end
