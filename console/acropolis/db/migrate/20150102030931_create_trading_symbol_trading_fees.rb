class CreateTradingSymbolTradingFees < ActiveRecord::Migration
  def change
    create_table :trading_symbol_trading_fees do |t|
      t.references :trading_symbol, index: true
      t.references :trading_fee, index: true

      t.timestamps
    end
  end
end
