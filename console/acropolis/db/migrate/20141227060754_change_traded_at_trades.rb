class ChangeTradedAtTrades < ActiveRecord::Migration
  def up
    rename_column :trades, :traded_at, :exchange_traded_at
  end

  def down
    rename_column :trades, :exchange_traded_at, :traded_at
  end
end
