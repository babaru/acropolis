class RiskPlan < ActiveRecord::Base
  belongs_to :parameter
  belongs_to :operation
  belongs_to :user
  belongs_to :product

  # attr_accessible :parameter_id

  validates :parameter_id, :presence => true
end
