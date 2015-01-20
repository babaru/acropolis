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

  validates :account_number, uniqueness: true

  PARAMETER_NAMES = %w(margin exposure profit position_cost trading_fee customer_benefit capital balance)

  #
  # Parameters
  #
  PARAMETER_NAMES.each do |method_name|
    define_method(method_name) do |date, exchange|
      conditions = build_trading_summary_query_condition(date, exchange)
      TradingSummary.where(conditions).inject(0) {|sum, item| sum += item.send(method_name.to_sym)}
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

  # def get_parameter_resource(name, default_value)
  #   TradingAccountParameter.find_by_trading_account_id_and_parameter_name(id,
  #     name) || TradingAccountParameter.create(trading_account_id: id,
  #       parameter_name: name, parameter_value: default_value)
  # end

  # ADDITIONAL_PARAMETERS.each do |method_name|
  #   define_method(method_name) do
  #     self.send(:get_parameter, method_name.to_sym, method_name == 'net_worth' ? 1 : 0)
  #   end

  #   define_method("#{method_name}=") do |val|
  #     self.send(:set_parameter, method_name.to_sym, val)
  #   end
  # end

  #
  # Calculate parameters
  #

  # def refresh_parameters(date)
  #   get_trading_summaries_by_date(date).each do |trading_summary|
  #     trading_summary.refresh_parameters
  #   end
  # end

  #
  # Handle trade updates
  #

  # def received_trade(trade)
  #   get_trading_summary(trade.exchange_id,
  #     trade.exchange_traded_at).calculate_parameters
  # end

  # def get_trading_summary(exchange_id, date)
  #   TradingSummary.find_by_exchange_id_and_trading_account_id_and_trading_date(exchange_id,
  #     id, date.strftime('%Y-%m-%d')) || TradingSummary.create(exchange_id: exchange_id,
  #     trading_account_id: id, trading_date: date.strftime('%Y-%m-%d'))
  # end

  # def get_trading_summaries_by_date(date)
  #   trading_summaries.where(trading_date: date.strftime('%Y-%m-%d'))
  # end

  #

  def margin_rate
    return 0 if self.capital.nil? || self.capital == 0
    return 0 if self.margin.nil?
    self.margin.fdiv(self.capital)
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
    2
  end

  private

  def build_trading_summary_query_condition(date, exchange)
    conditions = build_trading_summary_query_by_date_condition(date)
    conditions = conditions.and(build_trading_summary_query_by_exchange_condition(exchange)) if exchange
    conditions
  end

  def build_trading_summary_query_by_exchange_condition(exchange)
    return nil if exchange.nil?
    TradingSummary.arel_table[:exchange_id].eq(exchange.id)
  end

  def build_trading_summary_query_by_date_condition(date)
    conditions = nil
    if date.nil?
      conditions = TradingSummary.arel_table[:trading_date].eq(
        TradingSummary.select(TradingSummary.arel_table[:trading_date].maximum).ast
      )
    else
      conditions = TradingSummary.arel_table[:trading_date].eq(date.utc)
    end
    conditions
  end

end
