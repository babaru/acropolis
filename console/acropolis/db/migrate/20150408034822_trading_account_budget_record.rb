class TradingAccountBudgetRecord < ActiveRecord::Migration
  def change
    change_table :trading_account_budget_records do |t|
        t.rename :type, :budget_type
    end
  end
end
