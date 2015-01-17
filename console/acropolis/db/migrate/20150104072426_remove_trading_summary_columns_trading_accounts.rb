class RemoveTradingSummaryColumnsTradingAccounts < ActiveRecord::Migration
  def up
    remove_column :trading_accounts, :net_worth
    remove_column :trading_accounts, :balance
    remove_column :trading_accounts, :exposure
    remove_column :trading_accounts, :leverage
    remove_column :trading_accounts, :margin
    remove_column :trading_accounts, :trading_fee
    remove_column :trading_accounts, :profit
    remove_column :trading_accounts, :customer_benefit
    remove_column :trading_accounts, :capital
    remove_column :trading_accounts, :position_cost
  end

  def down
    change_table :trading_accounts do |t|
      t.decimal :net_worth, precision: 20, scale: 4, default: 1
      t.decimal :balance, precision: 20, scale: 4, default: 0
      t.decimal :exposure, precision: 20, scale: 4, default: 0
      t.decimal :leverage, precision: 20, scale: 4, default: 0
      t.decimal :margin, precision: 20, scale: 4, default: 0
      t.decimal :trading_fee, precision: 20, scale: 4, default: 0
      t.decimal :profit, precision: 20, scale: 4, default: 0
      t.decimal :customer_benefit, precision: 20, scale: 4, default: 0
      t.decimal :capital, precision: 20, scale: 4, default: 0
      t.decimal :position_cost, precision: 20, scale: 4, default: 0
    end
  end
end
