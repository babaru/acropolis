class AddNameUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :name
      t.string :full_name
    end
  end
end
