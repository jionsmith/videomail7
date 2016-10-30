class AddTokenToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :token, :string
    add_index :messages, :token

    Message.find_each do |msg|
      msg.set_token
      msg.save validate: false
    end
  end
end
