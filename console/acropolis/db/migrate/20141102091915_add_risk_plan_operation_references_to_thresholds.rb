class AddRiskPlanOperationReferencesToThresholds < ActiveRecord::Migration
  def change
    change_table :thresholds do |t|
      t.remove_references :risk_plan
      t.references :risk_plan_operation, index: true
    end
  end
end
