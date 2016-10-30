class CreateMessageAccessLogs < ActiveRecord::Migration
  def change
    create_table :message_access_logs do |t|
      t.references :message, index: true
      t.string :email
      t.datetime :accessed_at
    end

    add_index :message_access_logs, :email
    add_index :message_access_logs, :accessed_at
  end
end
