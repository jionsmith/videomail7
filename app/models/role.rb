class Role < ActiveRecord::Base
  has_and_belongs_to_many :accounts, :join_table => :accounts_roles
  belongs_to :resource, :polymorphic => true
  
  scopify
end
