class AddExchangeColumnsTradingSummaries < ActiveRecord::Migration
  def change
    change_table :trading_summaries do |t|
      t.datetime :trading_date
      t.references :exchange, index: true
      t.references :latest_trade, index: true
    end
  end
end
