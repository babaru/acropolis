class CreateMarketPrices < ActiveRecord::Migration
  def change
    create_table :market_prices do |t|
      t.references :instrument, index: true
      t.decimal :price, precision: 20, scale: 4

      t.timestamps
    end
  end
end
