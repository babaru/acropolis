class CreateInstruments < ActiveRecord::Migration
  def change
    create_table :instruments do |t|
      t.string :name
      t.string :symbol_id
      t.string :type
      t.references :underlying, index: true
      t.datetime :expiration_date
      t.decimal :strike_price, precision: 20, scale: 4
      t.references :exchange, index: true

      t.timestamps
    end
  end
end
