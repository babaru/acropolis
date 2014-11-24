class ChangeCurrencyToTradingSymbols < ActiveRecord::Migration
  def up
    change_table :instruments do |t|
      t.remove_references :currency
    end

    change_table :trading_symbols do |t|
      t.references :currency, index: true
    end
  end

  def down
    change_table :instruments do |t|
      t.references :currency, index: true
    end

    change_table :trading_symbols do |t|
      t.remove_references :currency
    end
  end
end
