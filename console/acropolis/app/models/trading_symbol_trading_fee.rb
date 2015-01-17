class TradingSymbolTradingFee < ActiveRecord::Base
  belongs_to :trading_symbol
  belongs_to :trading_fee
end
