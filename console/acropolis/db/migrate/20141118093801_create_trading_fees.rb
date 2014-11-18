class CreateTradingFees < ActiveRecord::Migration
  def change
    create_table :trading_fees do |t|
      t.string :type
      t.decimal :factor, precision: 20, scale: 4
      t.references :instrument, index: true

      t.timestamps
    end
  end
end
