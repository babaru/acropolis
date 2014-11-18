class FixedRateMargin < Margin

  def calculate(position)
    position_worth = position.trade_price * position.open_volume * position.instrument.multiplier
    position_worth * factor
  end

end