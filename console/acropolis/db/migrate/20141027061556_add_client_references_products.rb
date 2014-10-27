class AddClientReferencesProducts < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.references :client, index: true
    end
  end
end
