module RiskParam
  def child_account(exchange_id)
    child_accounts.each {|ca| return ca if ca.exchange_id == exchange_id}
    ChildAccount.create(trading_account_id: self.id, exchange_id: exchange_id)
  end

  def update(trade)
    child_account(trade.exchange_id).update(trade)
  end

  %w[customer_benefit capital balance profit position_cost budget exposure margin].each do |param|
    define_method(param) do
      child_accounts.inject(0) { |sum, ca| sum += ca.send(param.to_sym) }
    end
  end

  def net_worth
    capital == 0 ? 0 : customer_benefit.fdiv(capital)
  end

  def leverage
    capital == 0 ? 0 : position_cost.fdiv(capital)
  end
end