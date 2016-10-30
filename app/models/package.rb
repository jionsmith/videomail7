class Package < ActiveRecord::Base
  has_and_belongs_to_many :templates
  has_one :product, as: :productable, dependent: :destroy
  
  accepts_nested_attributes_for :product, update_only: true
  validates :product, :name, presence: true

  scope :by_name, -> { order('name ASC') }

  def product_name
    self.name
  end
end
