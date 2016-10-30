class EncodeVideo
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(id)
    video = Video.find_by_id(id)
    return unless video

    if video.panda_video_id.blank?
      attrs = {}
      if video.stream_name_url.start_with? 'http'
        attrs[:source_url] = video.stream_name_url
      else
        attrs[:file] = File.new(video.stream_name_url)
      end

      panda_video = Panda::Video.create!(attrs)
      video.panda_video_id = panda_video.id
      video.save
    end
  end
end
