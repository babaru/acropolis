class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.references :instrument, index: true
      t.decimal :trade_price, precision: 20, scale: 4
      t.integer :order_side, default: 0
      t.decimal :order_price, precision: 20, scale: 4
      t.references :trading_account, index: true
      t.datetime :traded_at
      t.integer :trade_volume
      t.decimal :exchange_fee, precision: 20, scale: 4
      t.decimal :broker_fee, precision: 20, scale: 4
      t.decimal :margin, precision: 20, scale: 4
      t.integer :open_close, default: 0

      t.timestamps
    end
  end
end
