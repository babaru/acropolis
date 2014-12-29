class AddNameColumnsTrades < ActiveRecord::Migration
  def change
    change_table :trades do |t|
      t.string :trading_account_number
      t.string :exchange_code
      t.string :exchange_instrument_code
    end
  end
end
