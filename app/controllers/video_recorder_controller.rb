class VideoRecorderController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def avc_settings
    render layout: false
  end

  def jpg_encoder_download
    render text: 'save=ok'
  end

  def record
    @video = current_account.videos.build
  end
end
