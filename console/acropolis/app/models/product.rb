class Product < ActiveRecord::Base
  belongs_to :client
  has_many :risk_plans
end
