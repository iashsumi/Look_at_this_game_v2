class AddBeforeResToScThreads < ActiveRecord::Migration[5.2]
  def change
    add_column :sc_threads, :before_res, :integer, after: :thread_created_at, comment: "前回のレス数"
  end
end
