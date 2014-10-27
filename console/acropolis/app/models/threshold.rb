class Threshold < ActiveRecord::Base
  belongs_to :risk_plan
  belongs_to :relation_symbol
end
