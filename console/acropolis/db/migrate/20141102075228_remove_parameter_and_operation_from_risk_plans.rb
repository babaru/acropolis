class RemoveParameterAndOperationFromRiskPlans < ActiveRecord::Migration
  def change
    change_table :risk_plans do |t|
      t.remove_references :parameter
      t.remove_references :operation
    end
  end
end
