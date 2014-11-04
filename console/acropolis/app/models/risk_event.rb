class RiskEvent < ActiveRecord::Base
  belongs_to :product
  belongs_to :operation
end
