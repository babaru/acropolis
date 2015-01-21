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

  scope :when, -> (day) { where(trading_date: (day.beginning_of_day..day.end_of_day))}
  scope :of_exchange, -> (exchange_id) { where(exchange_id: exchange_id)}
  scope :whose, -> (trading_account_id) { where(trading_account_id: trading_account_id)}
  scope :latest_record, -> { order(TradingSummary.arel_table[:trading_date]).reverse_order.first }

  def self.latest_trading_date(trading_account_id)
    record = TradingSummary.whose(trading_account_id).latest_record
    return record.trading_date if record
    nil
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
  end

  #
  # Parameters calculation
  #

  def refresh_parameters
    self.update(latest_trade_id: nil)
    calculate_parameters
  end

  def calculate_parameters
    awaiting_trades.each do |trade|
      trade.close_position

      PARAMETER_NAMES.each do |parameter_name|
        value = self.send(parameter_name.to_sym)
        set_parameter(parameter_name, value + trade.send(parameter_name.to_sym))
      end

      ADDITIONAL_PARAMETERS.each do |parameter_name|
        self.send("calculate_#{parameter_name}") if parameter_name != 'capital'
      end

      self.latest_trade = trade
    end

    self.save
  end

  def awaiting_trades
    latest_trade_sequence_number = 0
    latest_trade_sequence_number = latest_trade.system_trade_sequence_number if latest_trade
    Trade.when(trading_date).after(latest_trade_sequence_number)
  end
end
