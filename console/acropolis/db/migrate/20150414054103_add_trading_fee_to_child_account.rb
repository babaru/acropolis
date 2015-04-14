class AddTradingFeeToChildAccount < ActiveRecord::Migration
  def change
    add_column :child_accounts, :trading_fee, :decimal, default: 0.0
  end
end
