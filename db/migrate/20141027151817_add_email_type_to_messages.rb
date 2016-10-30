class AddEmailTypeToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :email_type, :integer
  end
end
