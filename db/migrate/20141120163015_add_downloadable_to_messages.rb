class AddDownloadableToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :downloadable, :boolean
  end
end
