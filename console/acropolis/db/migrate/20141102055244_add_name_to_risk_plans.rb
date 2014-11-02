class AddNameToRiskPlans < ActiveRecord::Migration
  def change
    change_table :risk_plans do |t|
      t.string :name
    end
  end
end
