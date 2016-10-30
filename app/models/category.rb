class Category < ActiveRecord::Base 
  extend ActsAsTree::TreeWalker
  
  acts_as_tree order: "name"

  has_and_belongs_to_many :products
  has_many :templates, :through => :products, :source => :productable, :source_type => 'Template'

  scope :default, -> { where(default: true) }

  validate :validate_parent
  validates_uniqueness_of :name, :scope => :parent_id

  def validate_parent
    errors.add(:parent, "can not be current category") if !self.parent.blank? and self.id == self.parent.id
  end

  def parents
    result = []
    parent = self.parent
    
    while !parent.blank?
      result << parent
      parent = parent.parent
    end

    result
  end

  def self.default_category
    Category.default.first
  end

  def self.root_category
    Category.find(Setting.value_by('root_category'))
  end

  def self.select_options
    options = []
    Category.walk_tree do |category, level|
      options << ["#{'--'*level}#{category.name}", category.id]
    end
    options
  end

end
