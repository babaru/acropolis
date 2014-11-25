class CreateTradingAccountBudgetRecords < ActiveRecord::Migration
  def change
    create_table :trading_account_budget_records do |t|
      t.references :trading_account, index: true
      t.string :type
      t.decimal :money, default: 0, precision: 20, scale: 4

      t.timestamps
    end
  end
end
