class TradingSummary < ActiveRecord::Base
  include Acropolis::ParameterAccessor
  include Acropolis::Calculators::CustomerBenefitCalculator
  include Acropolis::Calculators::NetWorthCalculator
  include Acropolis::Calculators::BalanceCalculator
  include Acropolis::Calculators::LeverageCalculator

  belongs_to :trading_account
  belongs_to :latest_trade, class_name: 'Trade'
  belongs_to :exchange
  has_many :trading_summary_parameters

  scope :on_trading_date, -> (day) { where(trading_date: (day.beginning_of_day..day.end_of_day))}
  scope :belongs_to_exchange, -> (exchange_id) { where(TradingSummary.arel_table[:exchange_id].eq(exchange_id))}
  scope :belongs_to_trading_account, -> (trading_account_id) { where(trading_account_id: trading_account_id)}
  scope :before_trading_date, -> (date) { where(TradingSummary.arel_table[:trading_date].lteq(date))}

  class << self
    def fetch_summaries(account_id, date, exchange)
      where(build_query_condition(account_id, date, exchange))
    end

    def build_query_condition(account_id, date, exchange)
      conditions = build_query_condition_by_date(account_id, date, exchange)
      conditions = conditions.and(arel_table[:exchange_id].eq(exchange.id)) if exchange
      conditions.and(arel_table[:trading_account_id].eq(account_id))
    end

    def build_query_condition_by_date(account_id, date, exchange)
      conditions = nil
      if date
        latest_trading_date = latest_trading_date(account_id, date, exchange)
        if latest_trading_date < date
          conditions = arel_table[:trading_date].eq(latest_trading_date)
        else
          conditions = arel_table[:trading_date].eq(date)
        end
      else
        top_trading_date = order(:trading_date).reverse_order.first
        top_trading_date_value = top_trading_date ? top_trading_date.trading_date : nil
        conditions = arel_table[:trading_date].eq(top_trading_date_value)
      end
      conditions
    end

    def latest(trading_account_id, date, exchange)
      return nil unless trading_account_id
      summaries = belongs_to_trading_account(trading_account_id)
      summaries.before_trading_date(date) if date
      summaries.belongs_to_exchange(exchange.id) if exchange
      summaries.order(trading_date: :desc).first
    end

    def latest_trading_date(trading_account_id, date, exchange)
      rec = latest(trading_account_id, date, exchange)
      rec ? rec.trading_date : nil
    end
  end


  ADDITIONAL_PARAMETERS = %w(customer_benefit balance net_worth leverage capital)

  def get_parameter_resource(name, default_value)
    TradingSummaryParameter.find_by_trading_summary_id_and_parameter_name(id,
      name) || TradingSummaryParameter.create(trading_summary_id: id,
        parameter_name: name, parameter_value: default_value)
  end

  ADDITIONAL_PARAMETERS.each do |method_name|
    define_method(method_name) do
      self.send(:get_parameter, method_name.to_sym, method_name == 'net_worth' ? 1 : 0)
    end

    define_method("#{method_name}=") do |val|
      self.send(:set_parameter, method_name.to_sym, val)
    end

    define_method("reset_#{method_name}") do
      self.send(:reset_parameter, method_name.to_sym, method_name == 'net_worth' ? 1 : 0)
    end
  end

  #
  # Parameters calculation
  #

  def refresh_parameters
    update(latest_trade_id: nil)
    Trade.reset_open_volumes(trading_account, trading_date, exchange)
    reset_parameters
    calc_params
  end

  def calc_params
    trades = awaiting_trades
    trades.each do |trade|
      trade.close_position
    end
    @latest_trade = trades.last
    latest_trade_id = @latest_trade.id

    Trade.trades_for(trading_account_id, trading_date, exchange_id).each do |trade|
      PARAMETER_NAMES.each do |param|
        value = send(param.to_sym)
        set_parameter(param, value + trade.send(param.to_sym))
      end
    end

    ADDITIONAL_PARAMETERS.each {|p| send("calculate_#{p}") if p != 'capital'}

    save
  end

  def reset_parameters
    PARAMETER_NAMES.each do |parameter_name|
      self.send("reset_#{parameter_name}")
    end

    ADDITIONAL_PARAMETERS.each do |parameter_name|
      self.send("reset_#{parameter_name}") if parameter_name != 'capital'
    end
  end

  def awaiting_trades
    last_seq_no = @latest_trade ? @latest_trade.system_trade_sequence_number : 0
    Trade.waiting_trades_for(trading_account_id, trading_date, exchange_id, last_seq_no)
  end
end
