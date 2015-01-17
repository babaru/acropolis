class RemoveTradingSymbolMargins < ActiveRecord::Migration
  def up
    change_table :margins do |t|
      t.remove_references :trading_symbol
    end
  end

  def down
    change_table :margins do |t|
      t.references :trading_symbol, index: true
    end
  end
end
