class AddPremiumToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :premium_template, :boolean, default: false
    add_index :templates, :premium_template
  end
end
