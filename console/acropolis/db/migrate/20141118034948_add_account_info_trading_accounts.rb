class AddAccountInfoTradingAccounts < ActiveRecord::Migration
  def change
    change_table :trading_accounts do |t|
      t.string :account_no
      t.string :password
      t.string :legal_id
    end
  end
end
