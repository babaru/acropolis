class CreateChildAccount < ActiveRecord::Migration
  def change
    create_table :child_accounts do |t|
      t.decimal :profit
      t.decimal :balance
      t.decimal :capital
      t.decimal :budget

      t.timestamps
    end
  end
end
