class AddPlaylistIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :playlist_id, :integer
    add_column :messages, :play, :string
    add_index :messages, :playlist_id
  end
end
