class AddOpenVolumeTrades < ActiveRecord::Migration
  def change
    change_table :trades do |t|
      t.integer :open_volume, default: 0
    end
  end
end
