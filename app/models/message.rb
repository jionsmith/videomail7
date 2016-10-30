class Message < ActiveRecord::Base
  include TokenGenerator
  acts_as_paranoid

  belongs_to :account, counter_cache: true
  belongs_to :video
  belongs_to :template
  belongs_to :playlist

  has_many :access_logs, -> { order "accessed_at desc" }, class_name: 'MessageAccessLog'
  scope :by_token, ->(token) { where(token: token) }
  scope :by_status, ->(status) { where(status: status) }
  scope :delayed_drafts, ->{ where("send_at is not null").where(status: 'delayed', email_type: 1).order('send_at desc') }

  validates_presence_of :template
  validates_length_of :text, maximum: 2048
  validates_length_of :subject, maximum: 255

  validate :validate_emails
  validate :validate_video_playlist
  validate :validate_template
  validate :validate_video
  validate :validate_delayed_email

  before_save :set_video_playlist

  STATUSES = %w(draft sent delayed)
  PLAY_TYPES = %w(video list)
  EMAIL_TYPES = %w(normal delayed)

  Message::STATUSES.each do |status|
    define_method("#{status}?") do
      self.status == status
    end
  end

  def clone_message
    message = self.dup
    message.token = nil
    message.created_at = message.updated_at = Time.now
    message.send_at = nil
    message.status = 'draft'
    message.save

    message
  end

  def emails_to_a
    self.emails.gsub(/\s+/, '').split(',')
  end

  def validate_emails
    errors.add(:emails, 'cannot be blank.') if self.emails.blank? || self.emails_to_a.count == 0
  end

  def validate_delayed_email
    if self.delayed_email? && self.draft? && (Time.now > self.send_at)
      errors.add(:send_at, 'cannot be before than now.')
    end
  end

  def validate_video_playlist
    if self.video_id.blank? and self.playlist_id.blank?
      errors.add(:play, 'video or playlist cannot be blank.')
    else
      errors.add(:playlist, "couldn't be blank") if self.play == 'list' && self.playlist_id == nil
      errors.add(:video, "couldn't be blank") if self.play != 'list' && self.video_id == nil
    end
  end

  def validate_template
    if template && account
      unless account.can_use_template?(template, persisted?)
        errors.add(:template, "can't be used, upgrade your plan")
      end
    end
  end

  def validate_video
    if video && account
      unless account.can_use_video_duration_of?(video.duration)
        errors.add(:video, "can't be used, your current plan has video duration limit, upgrade your plan")
      end
    end
  end

  def delayed_email?
    self.email_type == 1
  end

  def deliver
    if self.delayed_email?
      deliver_later
    else
      deliver_now
    end
  end

  def deliver_now
    self.emails_to_a.each do |email|
      VideoMailer.template_email(self, email).deliver
    end
    self.status = 'sent'
    self.send_at = Time.now
    self.save
  end

  def deliver_later
    self.status = 'delayed'
    self.save
  end

  def self.deliver_delayed
    Message.delayed_drafts.where('send_at < ?', Time.now).each do |message|
      message.deliver_now
    end
  end

  def read_by!(email)
    last_accessed_at = self.access_logs.by_email(email).first.try(:accessed_at) || 1.year.ago
    if last_accessed_at < 5.minutes.ago
      self.access_logs.create(email: email, accessed_at: Time.now)
    end
  end

  def read_by?(email)
    !self.access_logs.where(email: email).blank?
  end
  
  def read_any?
    self.access_logs.count > 0
  end

  private

  def set_video_playlist
    if self.play == 'list'
      self.video_id = nil
    else
      self.playlist_id = nil
    end
  end

end
