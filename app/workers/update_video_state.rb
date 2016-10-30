class UpdateVideoState
  
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(id)
    video = Video.find_by_id(id)
    return unless video

    if video.panda_video.status == 'fail'
      # video failed to be uploaded to your bucket
      # Logs go here to show this Issue
    else
      video.panda_video.encodings.each do |encoding|
        if encoding.status == "success"
          video.cache_panda_attrs(encoding.profile_name)
          video.save(validate: false)
        else
          Sidekiq.logger.warn "Failed #{encoding.error_class}: #{encoding.error_message}"
        end
      end
    end
  end

end
