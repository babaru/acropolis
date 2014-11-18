class FixedTradingFee < TradingFee

  def calculate(trade)
    return self.factor * trade.trade_volume
  end

end