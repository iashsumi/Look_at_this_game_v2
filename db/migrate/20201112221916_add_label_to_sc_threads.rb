class AddLabelToScThreads < ActiveRecord::Migration[5.2]
  def change
    add_column :sc_threads, :label, :string, after: :thread_created_at
  end
end
