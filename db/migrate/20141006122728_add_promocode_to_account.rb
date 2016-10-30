class AddPromocodeToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :promotion_code, :string
    add_column :accounts, :referrer_code, :string
    add_column :accounts, :bonofa_partner_account_id, :integer
    add_index :accounts, :bonofa_partner_account_id
  end
end
