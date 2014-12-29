class ChangeNameExchanges < ActiveRecord::Migration
  def up
    rename_column :exchanges, :name, :trading_code
  end

  def down
    rename_column :exchanges, :trading_code, :name
  end
end
