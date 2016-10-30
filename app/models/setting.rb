class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true

  KEYS = %w(root_category)

  def self.value_by(key)
    Setting.object_by(key).try(:value)
  end

  def self.object_by(key)
    if Setting::KEYS.include? key
      return Setting.find_or_create_by(key: key)
    else
      return nil
    end
  end
end