class TradingSummary < ActiveRecord::Base
  include Acropolis::ParameterAccessor

  belongs_to :trading_account
  belongs_to :latest_trade, class_name: 'Trade'
  belongs_to :exchange
  has_many :parameters, class_name: :TradingSummaryParameter, dependent: :destroy

  scope :on_trading_date, -> (day) { where(trading_date: (day.beginning_of_day..day.end_of_day))}
  scope :belongs_to_exchange, -> (exchange_id) { where(TradingSummary.arel_table[:exchange_id].eq(exchange_id))}
  scope :belongs_to_trading_account, -> (trading_account_id) { where(trading_account_id: trading_account_id)}
  scope :before_trading_date, -> (date) { where(TradingSummary.arel_table[:trading_date].lteq(date))}

  param_accessor :profit
  param_accessor :trading_fee
  param_accessor :balance
  param_accessor :budget
  param_accessor :capital

  extend Acropolis::ParameterAggregation
  param_aggregation :exposure, from: :open_trades
  param_aggregation :position_cost, from: :open_trades
  param_aggregation :margin, from: :open_trades
  param_aggregation :market_value, from: :open_trades

  def update_trade(trade)
    rest_volume = trade.traded_volume
    TradingSummary.transaction do
      trade.available_open_trades.each do |open_trade|
        close_volume = open_trade.close_position_with(trade)

        # return margin
        margin =  open_trade.calc_margin(open_trade.market_price, close_volume)
        update_margin (-1 * margin)

        profit = open_trade.calc_close_profit(trade.traded_price, close_volume)
        update_profit profit

        rest_volume -= close_volume
        break if rest_volume == 0
      end
      update_trading_fee trade.trading_fee
      update_margin trade.margin
      save!
    end
  end

  class << self
    def update_trade(trade)
      ts = latest_for(trade) || create_summary_for(trade)
      ts.update_trade trade
    end

    def create_summary_for(trade)
      latest_ts = latest(trade.trading_account_id, trade.exchange, trade.exchange_traded_at)
      ts = TradingSummary.create(trading_account_id: trade.trading_account_id,
                                 exchange_id: trade.exchange_id,
                                 trading_date: trade.exchange_traded_at)
      if latest_ts
        if latest_ts.trading_date.beginning_of_day != ts.trading_date.beginning_of_day
          ts.profit = 0
          ts.trading_fee = 0
        else
          ts.profit = latest_ts.profit
          ts.trading_fee = latest_ts.trading_fee
        end

        ts.budget = latest_ts.budget
        ts.balance = latest_ts.balance
        ts.capital = latest_ts.capital
        ts.save!
      end
      ts
    end

    # if exchange_id is not given, fetch latest summaries of all exchanges;
    # is date is not given, fetch latest summaries of given exchanges in today.
    def fetch_summaries(account_id, exchange_id = nil, date = nil)
      date = Time.now unless date

      summaries = belongs_to_trading_account(account_id)
                  .on_trading_date(date)
                  .order(updated_at: :desc )
      summaries.belongs_to_exchange(exchange_id) if exchange_id

      exchanges = Set.new
      summaries.select do |s|
        if exchanges.include? s.exchange_id
          false
        else exchanges.include? s.exchange_id
        exchanges << s.exchange_id
        true
        end
      end
    end

    def latest_for(trade)
      return nil unless trade.trading_account_id
      belongs_to_trading_account(trade.trading_account_id)
      .on_trading_date(trade.exchange_traded_at)
      .belongs_to_exchange(trade.exchange_id)
      .order(updated_at: :desc).first
    end

    def latest(trading_account_id, exchange_id, date)
      return nil unless trading_account_id
      summaries = belongs_to_trading_account(trading_account_id)
      summaries.belongs_to_exchange(exchange_id) if exchange_id
      summaries.before_trading_date(date) if date
      summaries.order(updated_at: :desc).first
    end

    def latest_trading_date(trading_account_id, exchange_id, date)
      rec = latest(trading_account_id, exchange_id, date)
      rec ? rec.trading_date : nil
    end
  end

  def open_trades
    Trade.open
        .not_been_closed
        .belongs_to_trading_account(trading_account_id)
        .belongs_to_exchange(exchange_id)
  end

=begin
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
=end

  def customer_benefit
    balance + profit + market_value - trading_fee
  end

  def net_worth
    capital == 0 ? 1 : customer_benefit.fdiv(capital)
  end

  def leverage
    capital == 0 ? 0 : position_cost.fdiv(capital)
  end


private

  def update_trading_fee(_trading_fee)
    self.balance = self.balance - _trading_fee
    self.trading_fee = self.trading_fee + _trading_fee
  end

  def update_profit(_profit)
    self.profit = self.profit + _profit
    self.balance = self.balance + _profit
  end

  def update_margin(_margin)
    self.balance = self.balance - _margin
  end
end

Trade.add_observer(TradingSummary, :update_trade)
