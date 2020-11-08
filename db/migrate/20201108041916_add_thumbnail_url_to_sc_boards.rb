class AddThumbnailUrlToScBoards < ActiveRecord::Migration[5.2]
  def change
    add_column :sc_boards, :thumbnail_url, :text, after: :threads_url
  end
end
