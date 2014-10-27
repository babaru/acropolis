class RiskPlan < ActiveRecord::Base
  belongs_to :parameter
  belongs_to :operation
  belongs_to :user
  belongs_to :product
  has_many :thresholds

  validates :parameter_id, :presence => true
end
