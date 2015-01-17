class CreateTradingSymbolMargins < ActiveRecord::Migration
  def change
    create_table :trading_symbol_margins do |t|
      t.references :trading_symbol, index: true
      t.references :margin, index: true

      t.timestamps
    end
  end
end
