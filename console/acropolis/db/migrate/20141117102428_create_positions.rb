class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :order_side, default: 0
      t.integer :volume
      t.decimal :trade_price, precision: 20, scale: 4
      t.references :instrument, index: true
      t.references :trading_account, index: true

      t.timestamps
    end
  end
end
