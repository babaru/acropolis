class AddCurrencyUnitInstruments < ActiveRecord::Migration
  def change
    change_table :instruments do |t|
      t.string :currency_unit
    end
  end
end
