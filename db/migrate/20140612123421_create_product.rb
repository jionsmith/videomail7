class CreateProduct < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :category_id
      t.money :price
      t.integer :status, default: 1
      t.references :productable, polymorphic: true
      t.timestamps
    end
  end
end