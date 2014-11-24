class ChangeColumnsInstruments < ActiveRecord::Migration
  def up
    change_table :instruments do |t|
      t.references :trading_symbol, index: true
      t.remove :symbol_id
      t.string :security_code
      t.references :currency, index: true
      t.remove :currency_unit
    end
  end

  def down
    change_table :instruments do |t|
      t.remove_references :trading_symbol, index: true
      t.string :symbol_id
      t.remove :security_code
      t.remove_references :currency, index: true
      t.string :currency_unit
    end
  end
end
