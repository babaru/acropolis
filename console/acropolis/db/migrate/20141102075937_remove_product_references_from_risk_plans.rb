class RemoveProductReferencesFromRiskPlans < ActiveRecord::Migration
  def change
    change_table :risk_plans do |t|
      t.remove_references :product
    end
  end
end
