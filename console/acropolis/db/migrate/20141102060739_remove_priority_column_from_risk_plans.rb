class RemovePriorityColumnFromRiskPlans < ActiveRecord::Migration
  def change
    change_table :risk_plans do |t|
      t.remove :priority
    end
  end
end
