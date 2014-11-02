class RemovePriorityColumnFromRiskPlans < ActiveRecord::Migration
  def up
    change_table :risk_plans do |t|
      t.remove :priority
    end
  end

  def down
    change_table :risk_plans do |t|
      t.integer :priority, default: 5
    end
  end
end
