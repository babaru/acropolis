class RemoveTradingSymbolIdTradingFees < ActiveRecord::Migration
  def up
    change_table :trading_fees do |t|
      t.remove_references :trading_symbol
    end
  end

  def down
    change_table :trading_fees do |t|
      t.references :trading_symbol, index: true
    end
  end
end
