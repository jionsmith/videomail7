class CreateAccountsTemplates < ActiveRecord::Migration
  def change
    create_table :accounts_templates do |t|
      t.belongs_to :account
      t.belongs_to :template
    end
  end
end
