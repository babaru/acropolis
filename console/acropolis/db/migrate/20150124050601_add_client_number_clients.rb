class AddClientNumberClients < ActiveRecord::Migration
  def change
    change_table :clients do |t|
      t.string :client_number
    end
  end
end
