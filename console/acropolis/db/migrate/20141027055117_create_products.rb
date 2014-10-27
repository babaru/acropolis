class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :bank
      t.string :broker
      t.string :long_name

      t.timestamps
    end
  end
end
