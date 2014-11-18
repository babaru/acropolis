class TradingAccount < ActiveRecord::Base
  belongs_to :product
  has_many :trades
  has_one :trading_account_trading_summary
  has_one :trading_summary, through: :trading_account_trading_summary
end
