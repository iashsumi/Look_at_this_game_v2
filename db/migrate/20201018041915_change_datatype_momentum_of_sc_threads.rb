class ChangeDatatypeMomentumOfScThreads < ActiveRecord::Migration[5.2]
  def up
    change_column :sc_threads, :momentum, :decimal, precision: 10, scale: 3
  end

  def down
    change_column :sc_threads, :momentum, :integer
  end
end
