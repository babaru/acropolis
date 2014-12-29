class AddMarginTrades < ActiveRecord::Migration
  def change
    change_table :trades do |t|
      t.decimal :exchange_margin, precision: 20, scale: 4, default: 0
      t.decimal :system_calculated_margin, precision: 20, scale: 4, default: 0
      t.decimal :exchange_trading_fee, precision: 20, scale: 4, default: 0
      t.decimal :system_calculated_trading_fee, precision: 20, scale: 4, default: 0
    end
  end
end
