class CreatePositionCloseRecords < ActiveRecord::Migration
  def change
    create_table :position_close_records do |t|
      t.references :open_trade, index: true
      t.references :close_trade, index: true
      t.integer :close_volume

      t.timestamps
    end
  end
end
