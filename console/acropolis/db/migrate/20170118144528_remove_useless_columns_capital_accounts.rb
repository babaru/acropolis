class RemoveUselessColumnsCapitalAccounts < ActiveRecord::Migration[5.0]
  def up
    remove_index :capital_accounts, :client_id
    remove_column :capital_accounts, :client_id
    remove_column :capital_accounts, :budget
  end

  def down
    add_column :capital_accounts, :budget, :integer, default: 0
    add_column :capital_accounts, :client_id, :integer
    add_index :capital_accounts, :client_id
  end
end
