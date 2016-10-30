class CreateAccountsProducts < ActiveRecord::Migration
  def change
    create_table :accounts_products do |t|
      t.belongs_to :account
      t.belongs_to :product
    end
  end
end
