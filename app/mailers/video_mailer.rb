class VideoMailer < ActionMailer::Base
  add_template_helper(VideoMailerHelper)
  default from: "no-reply@videomail7.com"

  def template_email(message, email)
    @message = message
    @video = @message.video
    @playlist = @message.playlist
    @template = @message.template
    @email = email
    mail(to: email, subject: message.subject, from: message.account.email)
  end
end
