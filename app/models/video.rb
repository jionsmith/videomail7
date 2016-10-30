class Video < ActiveRecord::Base
  belongs_to :account, counter_cache: true
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :playlists

  validates_presence_of :panda_video_id, if: 'stream_name.blank?'
  validates_presence_of :stream_name, if: 'panda_video_id.blank?'
  validates :title, :presence => true, :length => { :minimum => 5 }, :on => [ :update ], if: 'encoded'

  scope :most_recent, -> { order('created_at DESC') }
  scope :encoded, -> { where(encoded: true) }

  after_save :encode_video, if: 'panda_video_id.blank?'
  before_save :entitle

  PANDA_PROFILE_NAMES = %w(h264 ogg)

  def formatted_title
    return self.title if !self.title.blank?
    return 'Untitled'
  end

  def status
    return 'encoded' if self.encoded
    return 'in encoding'
  end

  def panda_video
    @panda_video ||= Panda::Video.find(self.panda_video_id)
  end

  def encodings
    @encodings ||= self.panda_video.encodings
  end

  def screenshots
    if self.panda_video_id
      @screenshots ||= self.encodings.first.screenshots
    else
      []
    end
  end

  def stream_name_url
     File.join(Rails.application.secrets[:hdfvr]['content_path'], self.stream_name) + '.flv'
  end

  def download_url
    s3 = AWS::S3.new
    s3_videos_bucket = Panda::Cloud.find(self.panda_video.cloud_id).s3_videos_bucket
    bucket = s3.buckets[s3_videos_bucket]
    object = bucket.objects[self.panda_video.encodings.last.files.first]
    object.url_for(:get, { 
      expires: 60.minutes,
      response_content_disposition: 'attachment;'
    }).to_s
  end

  def cache_panda_attrs(encoding_name)
    encoding = self.encodings[encoding_name]
    self.screenshot ||= encoding.screenshots.first
    self.height ||= encoding.height
    self.width ||= encoding.width
    self.encoded = true
    self.file_size ||= self.panda_video.file_size
    self.duration ||= self.panda_video.duration
    self.send("#{encoding_name}_url=", encoding.url)
  end

  def refresh
    if panda_video_id.blank?
      self.encode_video
    else
      self.encodings.each do |encoding|
        if encoding.status == 'success'
          self.cache_panda_attrs(encoding.profile_name)
          self.save(validate: false)
        end
      end
    end
  end

  def self.accept_upload?(file_name)
    mime_type = Rack::Mime.mime_type(File.extname(file_name))
    mime_type.start_with? 'video'
  end

  def is_accessible?(account, token)
    if self.account == account
      # Owner
      true
    else
      messages.by_token(token).exists?
    end
  end

  def encode_video
    EncodeVideo.perform_async(self.id)
  end

  private

  def entitle
    self.title ||= "Untitled #{self.account.videos.count}"
  end
end
