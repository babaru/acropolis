class AddClientTradingAccounts < ActiveRecord::Migration
  def change
    change_table :trading_accounts do |t|
      t.references :client, index: true
    end
  end
end
