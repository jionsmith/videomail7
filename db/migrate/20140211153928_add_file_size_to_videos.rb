class AddFileSizeToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :file_size, :string
  end
end
