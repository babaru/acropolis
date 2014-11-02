class ProductRiskPlan < ActiveRecord::Base
  belongs_to :product
  belongs_to :risk_plan
end
