class Client < ActiveRecord::Base
  has_many :products
  has_many :capital_accounts
  has_many :trading_accounts

  def margin(trade)
    if trade.instrument.trading_symbol.margin.nil?
      return 0
    else
      return trade.instrument.trading_symbol.margin.calculate(trade)
    end
  end

  def trading_fee(trade)
    if trade.instrument.trading_symbol.trading_fee.nil?
      return 0
    else
      return trade.instrument.trading_symbol.trading_fee.calculate(trade)
    end
  end
end
