class RenameContentColumnToContentFileFromTemplates < ActiveRecord::Migration
  def change
    rename_column :templates, :content, :content_file
  end
end
