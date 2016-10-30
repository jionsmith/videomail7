class RemoveCssColumnFromTemplates < ActiveRecord::Migration
  def change
    remove_column :templates, :css, :string
  end
end
