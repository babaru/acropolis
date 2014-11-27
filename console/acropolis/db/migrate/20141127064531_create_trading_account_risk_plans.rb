class CreateTradingAccountRiskPlans < ActiveRecord::Migration
  def change
    create_table :trading_account_risk_plans do |t|
      t.references :trading_account, index: true
      t.references :risk_plan, index: true
      t.boolean :is_enabled, default: true
      t.datetime :begun_at
      t.datetime :ended_at
      t.string :type

      t.timestamps
    end
  end
end
