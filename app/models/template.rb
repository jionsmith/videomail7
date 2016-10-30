class Template < ActiveRecord::Base
  belongs_to :author_account, class_name: 'Account', foreign_key: :account_id, inverse_of: :authored_templates
  belongs_to :video
  has_one :product, as: :productable, dependent: :destroy
  has_many :template_images, inverse_of: :template, dependent: :destroy

  has_and_belongs_to_many :accounts
  has_and_belongs_to_many :packages

  has_many :categories, :through=>:product

  scope :free_templates, ->{ joins(:product).where('products.price_cents = 0') }
  scope :premium_templates, ->{ where(premium_template: true) }
  scope :not_premium_templates, ->{ where.not(premium_template: true) }
  scope :enabled_templates, ->{ joins(:product).where('products.status = 1') }
  scope :by_title, -> { order('title ASC') }
  scope :by_product_status, ->{ joins(:product).order('products.status desc') }
  scope :by_category, ->(category = nil) {
    template_ids = category.templates.map(&:id)
    where(id: template_ids)
  }

  mount_uploader :content_file, TemplateContentUploader
  mount_uploader :preview_image, ImageUploader

  accepts_nested_attributes_for :product, update_only: true
  accepts_nested_attributes_for :template_images, reject_if: :all_blank, allow_destroy: true

  validates :product, :content_file, presence: true
  validates_uniqueness_of :title, :scope => :premium_template

  def product_name
    self.title
  end

  def description
    self.text_example
  end

  def liquid_template
    source = content_file.read rescue 'Template content file not found'

    template_images.each do |template_image|
      source.gsub! /\b#{template_image.image_name}\b/, template_image.image_file.url
    end

    Liquid::Template.parse(source)
  end

  def is_free?
    product.is_free?
  end

  def is_default?
    self.categories.include? Category.default_category
  end

  def related_products
    self.product.categories.first.products.templates rescue []
  end

  def self.default_templates
    Category.default_category.templates
  end

  def self.create_from_folder(template_folder, author_account, premium_template)
    content_file = Dir[template_folder + '*.{liquid,html}']
    raise "Can't find template: #{content_file}" unless content_file.count == 1
    content_file = content_file[0]

    preview_image = Dir[template_folder + 'preview.{jpg,png}']
    raise "Can't find preview image: #{preview_image}" unless preview_image.count == 1
    preview_image = preview_image[0]

    template = Template.where(title: template_folder.basename.to_s, premium_template: premium_template).first
    if template.blank?
      template = Template.new title: template_folder.basename.to_s,
                              content_file: File.new(content_file),
                              preview_image: File.new(preview_image),
                              author_account: author_account,
                              video: author_account.videos.first,
                              premium_template: premium_template
      template.build_product price_cents: 0, status: 1, productable: template

      Dir[template_folder + '*.{jpg,png}'].each do |image|
        next if image == preview_image

        template.template_images.build image_file: File.new(image)
      end

      template.save!
    else
      Template.update template.id, content_file: File.new(content_file), 
                              preview_image: File.new(preview_image), 
                              author_account: author_account,
                              video: author_account.videos.first,
                              premium_template: premium_template

      template.save!
    end
    template
  end

  def self.import_from_subfolders(parent_folder, author_account, premium_template)
    stat = { created: [], skipped: [] }

    Pathname(parent_folder).children.each do |folder|
      next unless folder.directory?
      puts folder.basename

      begin
        template = create_from_folder(folder, author_account, premium_template)
        puts "\tcreated: #{template.id}"
        stat[:created] << template.id
      rescue => ex
        puts "\terror: #{ex.message}"
        stat[:skipped] << folder.to_s
      end
    end

    stat
  end
end
