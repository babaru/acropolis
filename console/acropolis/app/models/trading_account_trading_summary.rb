class TradingAccountTradingSummary < ActiveRecord::Base
  belongs_to :trading_account
  belongs_to :trading_summary
end
