class CreateTradingAccountParameters < ActiveRecord::Migration
  def change
    create_table :trading_account_parameters do |t|
      t.references :trading_account, index: true
      t.string :parameter_name
      t.decimal :parameter_value, precision: 20, scale: 4, default: 0

      t.timestamps
    end
  end
end
