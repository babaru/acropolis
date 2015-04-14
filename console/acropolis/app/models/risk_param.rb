module RiskParam
  %w[customer_benefit capital balance profit position_cost budget exposure margin trading_fee].each do |param|
    define_method(param) do
      child_accounts.inject(0) { |sum, ca| sum += ca.send(param.to_sym) }
    end
  end

  def child_account(exchange_id)
    ret = child_accounts.belongs_to_exchange(exchange_id)
    ret.nil? ? ChildAccount.create(trading_account_id: self.id, exchange_id: exchange_id)
              : ret
  end

  def update_trade(trade)
    child_account(trade.exchange_id).update_trade(trade)
  end

  def net_worth
    capital == 0 ? 0 : customer_benefit.fdiv(capital)
  end

  def leverage
    capital == 0 ? 0 : position_cost.fdiv(capital)
  end
end