class RemoveParameterColumnsTradingSummaries < ActiveRecord::Migration
  def up
    remove_column :trading_summaries, :net_worth
    remove_column :trading_summaries, :balance
    remove_column :trading_summaries, :exposure
    remove_column :trading_summaries, :leverage
    remove_column :trading_summaries, :margin
    remove_column :trading_summaries, :trading_fee
    remove_column :trading_summaries, :profit
    remove_column :trading_summaries, :customer_benefit
  end

  def down
    add_column :trading_summaries, :net_worth, :decimal, precision: 20, scale: 4, default: 1
    add_column :trading_summaries, :customer_benefit, :decimal, precision: 20, scale: 4, default: 0
    add_column :trading_summaries, :leverage, :decimal, precision: 20, scale: 4, default: 0
    add_column :trading_summaries, :margin, :decimal, precision: 20, scale: 4, default: 0
    add_column :trading_summaries, :exposure, :decimal, precision: 20, scale: 4, default: 0
    add_column :trading_summaries, :profit, :decimal, precision: 20, scale: 4, default: 0
    add_column :trading_summaries, :balance, :decimal, precision: 20, scale: 4, default: 0
    add_column :trading_summaries, :trading_fee, :decimal, precision: 20, scale: 4, default: 0
  end
end
