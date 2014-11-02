class Threshold < ActiveRecord::Base
  belongs_to :risk_plan_operation
  belongs_to :relation_symbol
  belongs_to :parameter

  # validates :risk_plan_id, presence: true
  # validates :relation_symbol_id, presence: true
end
