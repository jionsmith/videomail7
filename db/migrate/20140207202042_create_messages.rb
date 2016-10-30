class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :text
      t.references :template, index: true
      t.references :video, index: true
      t.references :account, index: true
      t.string :status, default: "draft"

      t.timestamps
    end
  end
end
