class MessageAccessLog < ActiveRecord::Base
  belongs_to :message
  scope :by_email, ->(email){ where(email: email).order('accessed_at desc') }
end
