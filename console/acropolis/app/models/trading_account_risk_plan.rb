class TradingAccountRiskPlan < ActiveRecord::Base
  belongs_to :trading_account
  belongs_to :risk_plan

  scope :available, -> {where(is_enabled: true)}
end
