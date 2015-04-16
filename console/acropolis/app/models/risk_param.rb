module RiskParam
  %w[customer_benefit capital balance profit position_cost budget exposure margin trading_fee].each do |param|
    define_method(param) do |exchange_id = nil, date = nil|
      summaries = TradingSummary.fetch_summaries(self.id, exchange_id, date)
      summaries.inject(0) { |sum, s| sum += s.send(param.to_sym) }
    end
  end

  def net_worth(exchange_id, date)
    total_capital = capital(exchange_id, date)
    total_capital == 0 ? 1 : customer_benefit(exchange_id, date).fdiv(total_capital)
  end

  def leverage(exchange_id, date)
    total_capital = capital(exchange_id, date)
    total_capital == 0 ? 0 : position_cost(exchange_id, date).fdiv(total_capital)
  end
end