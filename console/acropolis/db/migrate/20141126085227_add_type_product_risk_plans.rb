class AddTypeProductRiskPlans < ActiveRecord::Migration
  def change
    change_table :product_risk_plans do |t|
      t.string :type, default: 'ProductRiskPlan'
    end
  end
end
