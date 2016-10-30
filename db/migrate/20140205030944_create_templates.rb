class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.references :account, index: true
      t.references :video, index: true
      t.string :title
      t.string :css
      t.string :content
      t.string :preview_image

      t.string :text_example


      t.timestamps
    end
  end
end
