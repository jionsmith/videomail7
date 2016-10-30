class AddOutroTextToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :outro_text, :text
  end
end
