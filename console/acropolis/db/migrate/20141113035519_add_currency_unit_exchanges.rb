class AddCurrencyUnitExchanges < ActiveRecord::Migration
  def change
    change_table :exchanges do |t|
      t.string :currency_unit
    end
  end
end
