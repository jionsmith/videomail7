class CreatePackagesTemplates < ActiveRecord::Migration
  def change
    create_table :packages_templates do |t|
      t.belongs_to :package
      t.belongs_to :template
    end
  end
end
