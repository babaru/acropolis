class ChangeNoToNumberTradingAccounts < ActiveRecord::Migration
  def up
    rename_column :trading_accounts, :account_no, :account_number
  end

  def down
    rename_column :trading_accounts, :account_number, :account_no
  end
end
