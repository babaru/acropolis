class CreateTradingAccountInstruments < ActiveRecord::Migration
  def change
    create_table :trading_account_instruments do |t|
      t.references :trading_account, index: true
      t.references :instrument, index: true

      t.timestamps
    end
  end
end
