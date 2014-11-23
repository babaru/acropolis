class TradingAccountInstrument < ActiveRecord::Base
  belongs_to :trading_account
  belongs_to :instrument
end
