class AddTradingFeeTradingSummaries < ActiveRecord::Migration
  def change
    change_table :trading_summaries do |t|
      t.decimal :trading_fee, precision: 20, scale: 4, default: 0
    end
  end
end
