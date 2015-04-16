class DropChildAccount < ActiveRecord::Migration
  def change
    drop_table :child_accounts
  end
end
