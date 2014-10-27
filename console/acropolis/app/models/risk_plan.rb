class RiskPlan < ActiveRecord::Base
  belongs_to :parameter
  belongs_to :operation
  belongs_to :user
  belongs_to :product
  has_many :thresholds

  # validates :parameter_id, :presence => true

  attr_accessor :threshold_ids, :threshold_relation_symbols, :threshold_values
end
