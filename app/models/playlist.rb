class Playlist < ActiveRecord::Base
  belongs_to :account

  has_and_belongs_to_many :videos
  has_many :messages, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :outro_text, length: { maximum: 255 }
  validates :description, length: { maximum: 255 }

  def screenshot
    self.videos.first.try(:screenshot)
  end

  def is_accessible?(account, token)
    if self.account == account
      # Owner
      true
    else
      messages.by_token(token).exists?
    end
  end
end
