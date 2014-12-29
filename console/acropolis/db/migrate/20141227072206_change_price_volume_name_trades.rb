class ChangePriceVolumeNameTrades < ActiveRecord::Migration
  def up
    rename_column :trades, :trade_volume, :traded_volume
    rename_column :trades, :trade_price, :traded_price
  end

  def down
    rename_column :trades, :traded_volume, :trade_volume
    rename_column :trades, :traded_price, :trade_price
  end
end
