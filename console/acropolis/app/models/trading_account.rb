class TradingAccount < ActiveRecord::Base
  attr_reader :budget

  belongs_to :product
  belongs_to :client
  has_many :trades, dependent: :destroy
  has_many :trading_summaries, dependent: :destroy
  has_many :trading_account_instruments, dependent: :destroy
  has_many :instruments, through: :trading_account_instruments
  has_many :trading_account_budget_records
  has_many :trading_account_risk_plans, dependent: :destroy
  has_many :risk_plans, through: :trading_account_risk_plans

  validates :account_number, uniqueness: true

  def budget=(val)
    @budget = val
  end

  PARAMETER_NAMES = %w(margin exposure profit position_cost trading_fee customer_benefit capital balance)

  #
  # Parameters
  #
  PARAMETER_NAMES.each do |param|
    define_method(param) do |date = nil, exchange = nil|
      TradingSummary.fetch_summaries(id, date, exchange).inject(0){|sum, summary| sum += summary.send(param.to_sym)}
    end
  end


  def net_worth(date = nil, exchange = nil)
    total_capital = capital(date, exchange)
    total_capital == 0 ? 0 : customer_benefit(date, exchange).fdiv(total_capital)
  end

  def leverage(date, exchange)
    total_capital = capital(date, exchange)
    total_capital == 0 ? 0 : position_cost(date, exchange).fdiv(total_capital)
  end

  #
  # Calculate parameters
  #

  def calc_params(date, exchange)
    TradingSummary.fetch_summaries(id, date, exchange).each {|s| s.calc_params}
  end

  def refresh_parameters(date, exchange)
    TradingSummary.fetch_summaries(id, date, exchange).each {|s| s.refresh_parameters}
  end

  def margin_rate
    return 0 if capital.nil? || capital == 0
    return 0 if margin.nil?
    margin.fdiv(capital)
  end

  def risk_plans_at(date)
    risk_plans = trading_account_risk_plans.available.where(
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
    0
  end
end
