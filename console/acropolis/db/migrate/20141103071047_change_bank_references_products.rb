class ChangeBankReferencesProducts < ActiveRecord::Migration
  def up
    change_table :products do |t|
      t.remove :bank
      t.references :bank, index: true
    end
  end

  def down
    change_table :products do |t|
      t.remove_references :bank
      t.string :bank
    end
  end
end
