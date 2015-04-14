class ChangeColumnsToRealDecimal < ActiveRecord::Migration
  def change
    change_column :child_accounts, :profit, :decimal, precision: 10, scale: 4
    change_column :child_accounts, :balance, :decimal, precision: 10, scale: 4
    change_column :child_accounts, :capital, :decimal, precision: 10, scale: 4
    change_column :child_accounts, :budget, :decimal, precision: 10, scale: 4
    change_column :child_accounts, :trading_fee, :decimal, precision: 10, scale: 4
    change_column :child_accounts, :margin, :decimal, precision: 10, scale: 4
  end
end
