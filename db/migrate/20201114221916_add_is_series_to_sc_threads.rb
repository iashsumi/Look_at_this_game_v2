class AddIsSeriesToScThreads < ActiveRecord::Migration[5.2]
  def change
    add_reference :sc_threads, :game, foreign_key: true
    add_column :sc_threads, :is_series, :boolean, after: :label, default: false, comment: "総合版かどうか"
  end
end
