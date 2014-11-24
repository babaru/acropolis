class ChangeTradingFeeMarginToTradingSymbols < ActiveRecord::Migration
  def up
    change_table :trading_fees do |t|
      t.remove_references :instrument
      t.references :trading_symbol, index: true
    end

    change_table :margins do |t|
      t.remove_references :instrument
      t.references :trading_symbol, index: true
    end
  end

  def down
    change_table :trading_fees do |t|
      t.remove_references :trading_symbol
      t.references :instrument, index: true
    end

    change_table :margins do |t|
      t.remove_references :trading_symbol
      t.references :instrument, index: true
    end
  end
end
