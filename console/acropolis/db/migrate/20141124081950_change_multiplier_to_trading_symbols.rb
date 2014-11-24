class ChangeMultiplierToTradingSymbols < ActiveRecord::Migration
  def up
    change_table :instruments do |t|
      t.remove :multiplier
    end

    change_table :trading_symbols do |t|
      t.decimal :multiplier, precision: 20, scale: 4
    end
  end

  def down
    change_table :instruments do |t|
      t.decimal :multiplier, precision: 20, scale: 4
    end

    change_table :trading_symbols do |t|
      t.remove :multiplier
    end
  end
end
