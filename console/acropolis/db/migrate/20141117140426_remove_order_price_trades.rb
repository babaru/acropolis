class RemoveOrderPriceTrades < ActiveRecord::Migration
  def change
    change_table :trades do |t|
      t.remove :order_price
    end
  end
end
