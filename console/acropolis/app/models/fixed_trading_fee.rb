class FixedTradingFee < TradingFee

  def calculate(trade)
    self.factor * trade.traded_volume * self.currency.exchange_rate
  end

end