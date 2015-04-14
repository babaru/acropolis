class TradingFee < ActiveRecord::Base
  belongs_to :currency
  has_one :trading_symbol_trading_fee
  has_one :trading_symbol, through: :trading_symbol_trading_fee

  def calculate(trade, price = nil, volume = nil)
    price = trade.traded_price unless price
    volume = trade.traded_volume unless volume
    factor * price * volume
  end
end
