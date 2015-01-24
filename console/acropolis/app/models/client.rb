class Client < ActiveRecord::Base
  has_many :trading_accounts

  PARAMETER_NAMES = %w(margin exposure profit position_cost trading_fee customer_benefit capital balance)

  #
  # Parameters
  #
  PARAMETER_NAMES.each do |method_name|
    define_method(method_name) do |date, exchange|
      trading_accounts.inject(0) {|sum, item| sum += item.send(method_name.to_sym, date, exchange)}
    end
  end

  def net_worth(date, exchange)
    total_captial = self.capital(date, exchange)
    return 0 if total_captial == 0
    self.customer_benefit(date, exchange).fdiv(total_captial)
  end

  def leverage(date, exchange)
    total_captial = self.capital(date, exchange)
    return 0 if total_captial == 0
    self.position_cost(date, exchange).fdiv(total_captial)
  end
end
