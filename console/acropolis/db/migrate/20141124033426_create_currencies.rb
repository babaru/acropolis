class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :code
      t.string :symbol
      t.decimal :exchange_rate, precision: 20, scale: 4
      t.boolean :is_major, default: false

      t.timestamps
    end
  end
end
