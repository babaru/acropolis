class AddPositionCostTradingAccounts < ActiveRecord::Migration
  def change
    change_table :trading_accounts do |t|
      t.decimal :position_cost, precision: 20, scale: 4, default: 0
    end
  end
end
