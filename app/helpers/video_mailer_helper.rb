module VideoMailerHelper
  def render_template_content_for_video(template, video, mail = {}, &block)
    content = capture(&block) if block
    mail_attrs = {
      'video_thumb' => video.try(:screenshot) || asset_url('140x140-default.png'),
      'video_name' => video.try(:title) || 'Video Title',
      'link' => template_path(template),
      'text' => template.text_example || 'EXAMPLE',
      'content_for_layout' => content
    }.merge(mail)

    template.liquid_template.render(mail_attrs).html_safe
  end

  def render_template_content_for_playlist(template, playlist, mail = {}, &block)
    content = capture(&block) if block
    mail_attrs = {
      'video_thumb' => playlist.try(:screenshot) || asset_url('140x140-default.png'),
      'video_name' => playlist.try(:title) || 'Playlist Title',
      'link' => template_path(template),
      'text' => template.text_example || 'EXAMPLE',
      'content_for_layout' => content
    }.merge(mail)

    template.liquid_template.render(mail_attrs).html_safe
  end
end
