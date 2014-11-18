class RemoveOrderPriceTrades < ActiveRecord::Migration
  def up
    change_table :trades do |t|
      t.remove :order_price
    end
  end

  def down
    change_table :trades do |t|
      t.decimal :order_price, precision: 20, scale: 4
    end
  end
end
