class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :account, index: true
      t.string :provider
      t.integer :uid
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end
