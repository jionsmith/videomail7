class AddStreamNameToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :stream_name, :string
  end
end
