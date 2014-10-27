class AddLevelOperations < ActiveRecord::Migration
  def change
    change_table :operations do |t|
      t.integer :level
    end
  end
end
