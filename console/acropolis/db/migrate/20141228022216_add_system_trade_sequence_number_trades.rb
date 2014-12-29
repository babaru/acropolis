class AddSystemTradeSequenceNumberTrades < ActiveRecord::Migration
  def change
    change_table :trades do |t|
      t.integer :system_trade_sequence_number, default: 0
    end
  end
end
