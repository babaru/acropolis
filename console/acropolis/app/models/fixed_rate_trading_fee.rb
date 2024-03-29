class FixedRateTradingFee < TradingFee

  def calculate(trade)
    self.factor * trade.traded_volume * trade.traded_price * self.currency.exchange_rate * trade.instrument.trading_symbol.multiplier
  end

end