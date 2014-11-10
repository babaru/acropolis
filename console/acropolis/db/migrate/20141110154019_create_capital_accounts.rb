class CreateCapitalAccounts < ActiveRecord::Migration
  def change
    create_table :capital_accounts do |t|
      t.string :name
      t.decimal :budget, precision: 20, scale: 4
      t.references :client, index: true

      t.timestamps
    end
  end
end
