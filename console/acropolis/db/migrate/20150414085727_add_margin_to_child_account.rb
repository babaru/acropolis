class AddMarginToChildAccount < ActiveRecord::Migration
  def change
    add_column :child_accounts, :margin, :decimal, default: 0.0
  end
end
