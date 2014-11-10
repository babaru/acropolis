class CreateTradingAccounts < ActiveRecord::Migration
  def change
    create_table :trading_accounts do |t|
      t.string :name
      t.decimal :budget, precision: 20, scale: 4
      t.references :product, index: true

      t.timestamps
    end
  end
end
