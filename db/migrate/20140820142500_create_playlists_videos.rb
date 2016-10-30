class CreatePlaylistsVideos < ActiveRecord::Migration
  def change
    create_table :playlists_videos do |t|
      t.integer :playlist_id
      t.integer :video_id
    end
  end
end
