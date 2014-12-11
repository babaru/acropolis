class TradingAccount < ActiveRecord::Base
  belongs_to :product
  has_many :trades, dependent: :destroy
  has_one :trading_account_trading_summary, dependent: :destroy
  has_one :trading_summary, through: :trading_account_trading_summary
  has_many :trading_account_instruments, dependent: :destroy
  has_many :instruments, through: :trading_account_instruments
  has_many :trading_account_budget_records
  has_many :trading_account_risk_plans, dependent: :destroy
  has_many :risk_plans, through: :trading_account_risk_plans

  def calculate_trading_summary
    TradingAccount.transaction do
      if self.trading_summary.nil?
        self.trading_summary = TradingSummary.new
        self.save
      end

      raw_summary = calculate_raw_summary

      self.trading_summary.customer_benefit = raw_summary[:customer_benefit]
      self.trading_summary.net_worth = raw_summary[:net_worth]
      self.trading_summary.margin = raw_summary[:margin]
      self.trading_summary.balance = raw_summary[:balance]
      self.trading_summary.leverage = raw_summary[:leverage]
      self.trading_summary.exposure = raw_summary[:exposure]
      self.trading_summary.profit = raw_summary[:customer_benefit] - self.budget
      self.trading_summary.trading_fee = raw_summary[:trading_fee]
      self.trading_summary.save
    end
  end

  def margin_rate
    return 0 if self.budget.nil? || self.budget == 0
    return 0 if self.margin.nil?
    self.margin.fdiv(self.budget)
  end

  #
  # Trading summary delegates
  #
  %w(balance margin leverage exposure customer_benefit net_worth profit trading_fee).each do |method_name|
    define_method(method_name) do
      return 0 unless self.trading_summary
      self.trading_summary.send(method_name.to_sym)
    end
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

  private

  def calculate_raw_summary
    trading_fee = 0
    profit = 0
    margin = 0
    exposure = 0
    position_cost = 0

    self.trades.open.each do |open_trade|
      open_trade.reset_position
    end

    self.trades.close.each do |close_trade|
      close_trade.close_position
    end

    self.trades.each do |trade|
      profit += trade.profit
      position_cost += trade.position_cost
      trading_fee += trade.trading_fee
      margin += trade.margin
      exposure += trade.exposure
    end

    customer_benefit = self.budget
    customer_benefit ||= 0
    customer_benefit += (profit - trading_fee)

    balance = self.budget
    balance ||= 0
    balance += (profit - trading_fee - margin)

    net_worth = 1
    if self.budget.nil? || self.budget == 0
      net_worth = 1
    else
      net_worth = customer_benefit.fdiv(self.budget)
    end

    leverage = position_cost
    if (self.budget.nil? || self.budget == 0)
      leverage = 0
    else
      leverage = position_cost.fdiv(self.budget)
    end

    {
      customer_benefit: customer_benefit,
      net_worth: net_worth,
      balance: balance,
      leverage: leverage,
      margin: margin,
      exposure: exposure.abs,
      trading_fee: trading_fee
    }
  end
end
