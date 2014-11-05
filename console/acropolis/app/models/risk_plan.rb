class RiskPlan < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :product_risk_plans, dependent: :delete_all
  has_many :products, through: :product_risk_plans
  has_many :risk_plan_operations, dependent: :destroy
end
