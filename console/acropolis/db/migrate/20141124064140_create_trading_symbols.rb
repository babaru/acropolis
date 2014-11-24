class CreateTradingSymbols < ActiveRecord::Migration
  def change
    create_table :trading_symbols do |t|
      t.string :name
      t.references :exchange, index: true

      t.timestamps
    end
  end
end
