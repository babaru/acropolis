class AddTradingSymbolTypeTradingSymbols < ActiveRecord::Migration
  def change
    change_table :trading_symbols do |t|
      t.integer :trading_symbol_type
    end
  end
end
