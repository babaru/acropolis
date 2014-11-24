class AddCurrencyTradingFees < ActiveRecord::Migration
  def change
    change_table :trading_fees do |t|
      t.references :currency
    end
  end
end
