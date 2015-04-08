class TradingFee < ActiveRecord::Base
  belongs_to :currency
  has_one :trading_symbol_trading_fee
  has_one :trading_symbol, through: :trading_symbol_trading_fee

  def calculate(trade)
    factor * trade.traded_volume * trade.traded_price
  end
end
