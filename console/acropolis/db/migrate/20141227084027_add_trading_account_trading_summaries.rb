class AddTradingAccountTradingSummaries < ActiveRecord::Migration
  def change
    change_table :trading_summaries do |t|
      t.references :trading_account, index: true
    end
  end
end
