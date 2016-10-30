class CreateTemplateImages < ActiveRecord::Migration
  def change
    create_table :template_images do |t|
      t.references :template, index: true
      t.string :image_name
      t.string :image_file

      t.timestamps
    end
    add_index :template_images, :image_name
  end
end
