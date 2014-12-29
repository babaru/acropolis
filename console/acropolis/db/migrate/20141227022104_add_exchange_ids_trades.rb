class AddExchangeIdsTrades < ActiveRecord::Migration
  def change
    change_table :trades do |t|
      t.string :exchange_trade_id
      t.integer :exchange_trade_sequence_number, default: 0
    end
  end
end
