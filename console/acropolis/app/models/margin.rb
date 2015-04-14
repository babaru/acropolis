class Margin < ActiveRecord::Base
  has_one :trading_symbol_margin
  has_one :trading_symbol, through: :trading_symbol_margin

  def value
    return 0 if self.factor.nil?
    self.factor
  end

  def calculate(trade, price = nil, volume = nil)
    price = trade.market_price unless price
    volume = trade.open_volume unless volume
    factor * price * volume
  end

end
