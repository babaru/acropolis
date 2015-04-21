class TradingAccount < ActiveRecord::Base

  belongs_to :product
  belongs_to :client
  has_many :trades, dependent: :destroy
  has_many :trading_summaries, dependent: :destroy
  has_many :trading_account_instruments, dependent: :destroy
  has_many :instruments, through: :trading_account_instruments
  has_many :trading_account_budget_records
  has_many :trading_account_risk_plans, dependent: :destroy
  has_many :risk_plans, through: :trading_account_risk_plans
  has_many :child_accounts, dependent: :destroy

  include RiskParam

  validates :account_number, uniqueness: true

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
