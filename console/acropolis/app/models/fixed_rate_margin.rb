class FixedRateMargin < Margin

  def calculate(position)
    position.position_cost * factor
  end

end