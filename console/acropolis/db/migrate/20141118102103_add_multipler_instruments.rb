class AddMultiplerInstruments < ActiveRecord::Migration
  def change
    change_table :instruments do |t|
      t.decimal :multiplier, precision: 20, scale: 4
    end
  end
end
