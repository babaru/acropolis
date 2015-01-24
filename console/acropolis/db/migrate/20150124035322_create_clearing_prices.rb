class CreateClearingPrices < ActiveRecord::Migration
  def change
    create_table :clearing_prices do |t|
      t.references :instrument, index: true
      t.decimal :price, precision: 20, scale: 4
      t.string :exchange_instrument_code
      t.datetime :cleared_at
      t.string :exchange_code

      t.timestamps
    end
  end
end
