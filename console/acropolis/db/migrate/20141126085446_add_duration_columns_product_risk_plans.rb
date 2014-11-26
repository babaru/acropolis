class AddDurationColumnsProductRiskPlans < ActiveRecord::Migration
  def change
    change_table :product_risk_plans do |t|
      t.datetime :begun_at
      t.datetime :ended_at
    end
  end
end
