class RenameUserToCreatedByOfRiskPlans < ActiveRecord::Migration
  def change
    change_table :risk_plans do |t|
      t.remove_references :user
      t.references :created_by
    end
  end
end
