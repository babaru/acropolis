class RemoveUselessColumnsProducts < ActiveRecord::Migration[5.0]
  def up
    remove_index :products, :client_id
    remove_column :products, :client_id
    remove_index :products, :broker_id
    remove_column :products, :broker_id
    remove_index :products, :bank_id
    remove_column :products, :bank_id
    remove_column :products, :budget
  end

  def down
    add_column :products, :client_id, :integer
    add_index :products, :client_id
    add_column :products, :broker_id, :integer
    add_index :products, :broker_id
    add_column :products, :bank_id, :integer
    add_index :products, :bank_id
    add_column :products, :budget, :integer, default: 0
  end
end
