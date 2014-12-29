class RenameBudgetTradingAccounts < ActiveRecord::Migration
  def up
    rename_column :trading_accounts, :budget, :capital
  end

  def down
    rename_column :trading_accounts, :capital, :budget
  end
end
