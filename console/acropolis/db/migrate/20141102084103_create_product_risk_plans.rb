class CreateProductRiskPlans < ActiveRecord::Migration
  def change
    create_table :product_risk_plans do |t|
      t.references :product, index: true
      t.references :risk_plan, index: true
      t.boolean :is_enabled, default: true

      t.timestamps
    end
  end
end
