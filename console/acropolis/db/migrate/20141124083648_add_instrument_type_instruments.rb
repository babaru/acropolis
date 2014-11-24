class AddInstrumentTypeInstruments < ActiveRecord::Migration
  def up
    change_table :instruments do |t|
      t.integer :instrument_type
      t.remove :type
    end
  end

  def down
    change_table :instruments do |t|
      t.remove :instrument_type
      t.string :type
    end
  end
end
