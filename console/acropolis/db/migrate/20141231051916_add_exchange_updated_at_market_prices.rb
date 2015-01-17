class AddExchangeUpdatedAtMarketPrices < ActiveRecord::Migration
  def change
    change_table :market_prices do |t|
      t.datetime :exchange_updated_at
    end
  end
end
