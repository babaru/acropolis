class TradingAccount < ActiveRecord::Base
  belongs_to :product
  has_many :trades, dependent: :destroy
  has_many :trading_summaries, dependent: :destroy
  has_many :trading_account_instruments, dependent: :destroy
  has_many :instruments, through: :trading_account_instruments
  has_many :trading_account_budget_records
  has_many :trading_account_risk_plans, dependent: :destroy
  has_many :risk_plans, through: :trading_account_risk_plans

  def calculate_trading_summary_after_trade(trade)
    leverage = 0
    net_worth = 1

    customer_benefit += (trade.profit -trade.trading_fee)
    position_cost += trade.position_cost
    profit += trade.profit
    trading_fee += trade.trading_fee
    margin += trade.margin
    exposure += trade.exposure
    balance += (trade.profit - trade.trading_fee - trade.margin)

    leverage = position_cost.fdiv(capital) if capital > 0
    net_worth = customer_benefit.fdiv(capital) if capital > 0

    save
  end

  def margin_rate
    return 0 if self.budget.nil? || self.budget == 0
    return 0 if self.margin.nil?
    self.margin.fdiv(self.budget)
  end

  def risk_plans_at(date)
    risk_plans = self.trading_account_risk_plans.available.where(
      TradingAccountRiskPlan.arel_table[:begun_at].lteq(date).and(
        TradingAccountRiskPlan.arel_table[:ended_at].gteq(date))
      )
  end

  def matched_operation(date)
    operation = nil
    risk_plans_at(date).each do |rp|
      new_operation = rp.risk_plan.matched_operation(self)
      if operation.nil?
        operation = new_operation
        next
      else
        if new_operation && new_operation.level > operation.level
          operation = new_operation
        end
      end
    end
    operation
  end

  #
  # Trading status of '0: normal', '1: forbid to open' and '2: force to close',
  # according to risk plan controlling
  #
  def trading_status
    mo = matched_operation(Time.now)
    return 0 if mo.nil?
    return 0 if mo.name.to_sym == :warning
    return 1 if mo.name.to_sym == :cease_open
    return 2 if mo.name.to_sym == :force_close
  end

end
