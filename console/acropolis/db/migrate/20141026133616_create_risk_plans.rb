class CreateRiskPlans < ActiveRecord::Migration
  def change
    create_table :risk_plans do |t|
      t.references :parameter, index: true
      t.references :operation, index: true
      t.integer :priority, default: 5
      t.boolean :is_enabled, default: false
      t.references :user, index: true
      t.references :product, index: true

      t.timestamps
    end
  end
end
