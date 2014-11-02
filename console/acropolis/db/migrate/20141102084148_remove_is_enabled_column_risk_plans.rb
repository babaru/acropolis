class RemoveIsEnabledColumnRiskPlans < ActiveRecord::Migration
  def up
    change_table :risk_plans do |t|
      t.remove :is_enabled
    end
  end

  def down
    change_table :risk_plans do |t|
      t.boolean :is_enabled, default: false
    end
  end
end
