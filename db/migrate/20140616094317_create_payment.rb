class CreatePayment < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :product_id
      t.integer :account_id
      
      t.boolean :status

      t.money :amount
      t.money :total
      t.money :netto
      t.money :tax

      t.string :charge_id
      t.string :card_id

      t.string :invoice

      t.timestamps
    end
  end
end
