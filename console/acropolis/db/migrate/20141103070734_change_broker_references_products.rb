class ChangeBrokerReferencesProducts < ActiveRecord::Migration
  def up
    change_table :products do |t|
      t.remove :broker
      t.references :broker, index: true
    end
  end

  def down
    change_table :products do |t|
      t.remove_references :broker
      t.string :broker
    end
  end
end
