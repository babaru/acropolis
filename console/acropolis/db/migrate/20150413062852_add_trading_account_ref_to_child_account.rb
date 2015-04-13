class AddTradingAccountRefToChildAccount < ActiveRecord::Migration
  def change
    add_reference :child_accounts, :trading_account, index: true
    add_foreign_key :child_accounts, :trading_accounts
  end
end
