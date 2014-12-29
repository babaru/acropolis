class SetDefaultValueTradingSummaries < ActiveRecord::Migration
  def up
    change_column :trading_summaries, :net_worth, :decimal, precision: 20, scale: 4, default: 0
    change_column :trading_summaries, :customer_benefit, :decimal, precision: 20, scale: 4, default: 0
    change_column :trading_summaries, :leverage, :decimal, precision: 20, scale: 4, default: 0
    change_column :trading_summaries, :margin, :decimal, precision: 20, scale: 4, default: 0
    change_column :trading_summaries, :exposure, :decimal, precision: 20, scale: 4, default: 0
    change_column :trading_summaries, :profit, :decimal, precision: 20, scale: 4, default: 0
    change_column :trading_summaries, :balance, :decimal, precision: 20, scale: 4, default: 0
  end

  def down
    change_column :trading_summaries, :net_worth, :decimal, precision: 20, scale: 4
    change_column :trading_summaries, :customer_benefit, :decimal, precision: 20, scale: 4
    change_column :trading_summaries, :leverage, :decimal, precision: 20, scale: 4
    change_column :trading_summaries, :margin, :decimal, precision: 20, scale: 4
    change_column :trading_summaries, :exposure, :decimal, precision: 20, scale: 4
    change_column :trading_summaries, :profit, :decimal, precision: 20, scale: 4
    change_column :trading_summaries, :balance, :decimal, precision: 20, scale: 4
  end
end
