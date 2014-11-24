class RemoveUnderlyingInstruments < ActiveRecord::Migration
  def up
    change_table :instruments do |t|
      t.remove_references :underlying
    end
  end

  def down
    change_table :instruments do |t|
      t.remove_references :underlying, index: true
    end
  end
end
