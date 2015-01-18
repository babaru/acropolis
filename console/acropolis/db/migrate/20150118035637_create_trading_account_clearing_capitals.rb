class CreateTradingAccountClearingCapitals < ActiveRecord::Migration
  def change
    create_table :trading_account_clearing_capitals do |t|
      t.references :trading_account, index: true
      t.datetime :cleared_at
      t.string :trading_account_number
      t.decimal :previous_currency_balance, precision: 20, scale: 4, default: 0
      t.decimal :incoming, precision: 20, scale: 4, default: 0
      t.decimal :profit, precision: 20, scale: 4, default: 0
      t.decimal :outgoing, precision: 20, scale: 4, default: 0
      t.decimal :fee, precision: 20, scale: 4, default: 0
      t.decimal :trading_fee, precision: 20, scale: 4, default: 0
      t.decimal :clearing_fee, precision: 20, scale: 4, default: 0
      t.decimal :delivery_fee, precision: 20, scale: 4, default: 0
      t.decimal :position_transfer_fee, precision: 20, scale: 4, default: 0
      t.decimal :currency_balance, precision: 20, scale: 4, default: 0
      t.decimal :margin, precision: 20, scale: 4, default: 0
      t.decimal :clearing_reserve, precision: 20, scale: 4, default: 0
      t.decimal :next_currency_balance, precision: 20, scale: 4, default: 0

      t.timestamps
    end
  end
end
