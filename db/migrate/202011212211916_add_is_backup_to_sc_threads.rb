class AddIsBackupToScThreads < ActiveRecord::Migration[5.2]
  def change
    add_column :sc_threads, :is_backup, :boolean, after: :is_series, default: false
  end
end
