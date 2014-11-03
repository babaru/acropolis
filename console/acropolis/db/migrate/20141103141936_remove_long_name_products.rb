class RemoveLongNameProducts < ActiveRecord::Migration
  def up
    change_table :products do |t|
      t.remove :long_name
    end
  end

  def down
    change_table :products do |t|
      t.string :long_name
    end
  end
end
