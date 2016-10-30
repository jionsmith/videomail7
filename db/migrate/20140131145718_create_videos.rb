class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.references :account, index: true
      t.string :title
      t.string :panda_video_id
      t.string :screenshot
      t.string :h264_url
      t.string :ogg_url
      t.string :height
      t.string :width
      t.boolean :encoded, default: false

      t.timestamps
    end
  end
end
