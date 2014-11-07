class CreateMonitoringProducts < ActiveRecord::Migration
  def change
    create_table :monitoring_products do |t|
      t.references :product, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
