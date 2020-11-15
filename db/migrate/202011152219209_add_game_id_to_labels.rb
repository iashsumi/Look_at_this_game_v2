class AddGameIdToLabels < ActiveRecord::Migration[5.2]
  def change
    add_reference :labels, :game, foreign_key: true
  end
end
