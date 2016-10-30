class AddDurationToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :duration, :float
    Video.find_each do |video|
      if !video.panda_video_id.blank?
        video.duration = video.panda_video.duration
        video.save validate: false
      end
    end
  end
end
