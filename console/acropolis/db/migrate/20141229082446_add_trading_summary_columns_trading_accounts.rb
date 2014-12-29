class AddTradingSummaryColumnsTradingAccounts < ActiveRecord::Migration
  def change
    change_table :trading_accounts do |t|
      t.decimal :net_worth, precision: 20, scale: 4, default: 1
      t.decimal :balance, precision: 20, scale: 4, default: 0
      t.decimal :exposure, precision: 20, scale: 4, default: 0
      t.decimal :leverage, precision: 20, scale: 4, default: 0
      t.decimal :margin, precision: 20, scale: 4, default: 0
      t.decimal :trading_fee, precision: 20, scale: 4, default: 0
      t.decimal :profit, precision: 20, scale: 4, default: 0
      t.decimal :customer_benefit, precision: 20, scale: 4, default: 0
    end
  end
end
