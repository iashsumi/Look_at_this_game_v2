class CreateConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :configurations do |t|
      t.string :name
      t.string :value, comment: "設定値"
    end
  end
end
