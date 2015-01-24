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

  def self.latest(trading_account_id, date, exchange)
    if date.nil?
      if exchange.nil?
        TradingSummary.belongs_to_trading_account(trading_account_id)
          .order(:trading_date).reverse_order.first
      else
        TradingSummary.belongs_to_trading_account(trading_account_id)
          .belongs_to_exchange(exchange.id)
          .order(:trading_date).reverse_order.first
      end
    else
      if exchange.nil?
        TradingSummary.belongs_to_trading_account(trading_account_id)
          .before_trading_date(date)
          .order(:trading_date).reverse_order.first
      else
        TradingSummary.belongs_to_trading_account(trading_account_id)
          .before_trading_date(date)
          .belongs_to_exchange(exchange.id)
          .order(:trading_date).reverse_order.first
      end
    end
  end

  def self.latest_trading_date(trading_account_id, date, exchange)
    latest_record = TradingSummary.latest(trading_account_id, date, exchange)
    return latest_record.trading_date if latest_record
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

    define_method("reset_#{method_name}") do
      self.send(:reset_parameter, method_name.to_sym, method_name == 'net_worth' ? 1 : 0)
    end
  end

  #
  # Parameters calculation
  #

  def refresh_parameters
    self.update(latest_trade_id: nil)
    Trade.reset_open_volumes(self.trading_account,
      self.trading_date, self.exchange)

    reset_parameters
    calculate_parameters
  end

  def calculate_parameters
    awaiting_trades.each do |trade|
      trade.close_position
      trade.calculate_trading_fee
      # trade.calculate_margin

      self.latest_trade = trade
    end

    Trade.when(trading_date).belongs_to_trading_account(self.trading_account_id)
    .belongs_to_exchange(self.exchange_id).order(:exchange_traded_at).each do |trade|
      PARAMETER_NAMES.each do |parameter_name|
        value = self.send(parameter_name.to_sym)
        set_parameter(parameter_name, value + trade.send(parameter_name.to_sym))
      end
    end

    ADDITIONAL_PARAMETERS.each do |parameter_name|
      self.send("calculate_#{parameter_name}") if parameter_name != 'capital'
    end

    self.save
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
    latest_trade_sequence_number = 0
    latest_trade_sequence_number = latest_trade.system_trade_sequence_number if latest_trade
    Trade.when(trading_date)
    .belongs_to_trading_account(self.trading_account_id)
    .belongs_to_exchange(self.exchange_id)
    .after(latest_trade_sequence_number)
  end
end
