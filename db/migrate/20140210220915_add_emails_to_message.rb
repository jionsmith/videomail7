class AddEmailsToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :emails, :text
  end
end
