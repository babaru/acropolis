class AddNameColumnsMarketPrices < ActiveRecord::Migration
  def change
    change_table :market_prices do |t|
      t.string :exchange_instrument_code
      t.string :exchange_code
    end
  end
end
