class Product < ActiveRecord::Base
  belongs_to :client
  has_many :product_risk_plans, dependent: :destroy
  has_many :risk_plans, through: :product_risk_plans
end
