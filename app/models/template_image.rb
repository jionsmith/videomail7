class TemplateImage < ActiveRecord::Base
  belongs_to :template

  mount_uploader :image_file, ImageUploader

  validates :template, :image_file, presence: true
  validates :image_name, presence: true, uniqueness: { scope: :template_id }

  before_validation do
    # if (image_file_changed? || image_name.blank?) && image_file?
    if image_name.blank? && image_file?
      self.image_name = image_file.filename
    end
  end
end
