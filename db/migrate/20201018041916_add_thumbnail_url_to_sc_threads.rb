class AddThumbnailUrlToScThreads < ActiveRecord::Migration[5.2]
  def change
    add_column :sc_threads, :thumbnail_url, :text, after: :url
  end
end
