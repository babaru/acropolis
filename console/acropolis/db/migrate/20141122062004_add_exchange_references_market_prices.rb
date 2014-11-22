class AddExchangeReferencesMarketPrices < ActiveRecord::Migration
  def change
    change_table :market_prices do |t|
      t.references :exchange, index: true
    end
  end
end
