class CreateRiskPlanOperations < ActiveRecord::Migration
  def change
    create_table :risk_plan_operations do |t|
      t.references :risk_plan, index: true
      t.references :operation, index: true
      t.boolean :is_enabled, default: true

      t.timestamps
    end
  end
end
