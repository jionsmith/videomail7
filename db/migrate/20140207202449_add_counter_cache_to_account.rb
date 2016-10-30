class AddCounterCacheToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :messages_count, :integer, default: 0
    add_column :accounts, :templates_count, :integer, default: 0
    add_column :accounts, :videos_count, :integer, default: 0
  end
end
