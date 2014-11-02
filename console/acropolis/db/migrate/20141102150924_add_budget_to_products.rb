class AddBudgetToProducts < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.integer :budget, default: 0
    end
  end
end
