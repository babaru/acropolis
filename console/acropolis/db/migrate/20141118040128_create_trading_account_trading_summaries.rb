class CreateTradingAccountTradingSummaries < ActiveRecord::Migration
  def change
    create_table :trading_account_trading_summaries do |t|
      t.references :trading_account, index: true
      t.references :trading_summary, index: true

      t.timestamps
    end
  end
end
