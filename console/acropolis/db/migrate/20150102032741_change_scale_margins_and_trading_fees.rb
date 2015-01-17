class ChangeScaleMarginsAndTradingFees < ActiveRecord::Migration
  def up
    change_column :margins, :factor, :decimal, precision: 16, scale: 8
    change_column :trading_fees, :factor, :decimal, precision: 16, scale: 8
  end

  def down
    change_column :margins, :factor, :decimal, precision: 20, scale: 4
    change_column :trading_fees, :factor, :decimal, precision: 20, scale: 4
  end
end
