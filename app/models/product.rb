class Product < ActiveRecord::Base
  monetize :price_cents

  belongs_to :productable, inverse_of: :product, polymorphic: true
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :accounts

  validate :validate_price

  STATUS = {
    enabled: 1,
    disabled: 0
  }

  TYPES = %w(template package)
  scope :enabled, ->{ where(status: 1) }
  scope :templates, ->{ where(productable_type: 'Template') }
  scope :packages, ->{ where(productable_type: 'Package') }

  Product::TYPES.each do |type|
    define_method("is_#{type}?") do
      self.productable_type.capitalize == type.capitalize
    end
  end

  def parent_object
    self.productable
  end

  def name
    self.parent_object.product_name
  end

  def formatted_status
    STATUS.index(self.status)
  end

  def validate_price
    errors.add(:price, 'can not be minus.') if self.price < 0
  end

  def is_free?
    self.price_cents == 0
  end

  def is_enabled?
    self.status == 1
  end
end
