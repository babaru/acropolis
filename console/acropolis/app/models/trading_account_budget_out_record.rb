class TradingAccountBudgetOutRecord < TradingAccountBudgetRecord
  def value
    return 0 - self.money
  end
end