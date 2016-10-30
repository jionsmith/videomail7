class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :account, index: true

      t.string :plan_type
      t.integer :status, default: 0

      t.integer :tax_cents
      t.integer :total_cents
      t.integer :subtotal_cents

      t.string :payment_method
      t.string :transaction_id

      t.string :invoice_file
      t.string :token
      t.string :first_name
      t.string :last_name
      t.string :card_brand
      t.string :last_4_digits

      t.text :info

      t.date :expired_at
      t.timestamps
    end

    add_index :orders, :plan_type
    add_index :orders, :status
    add_index :orders, :expired_at
  end
end
