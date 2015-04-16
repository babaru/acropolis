class TradingSummary < ActiveRecord::Base
  #include Acropolis::ParameterAccessor
  #include Acropolis::Calculators::CustomerBenefitCalculator
  #include Acropolis::Calculators::NetWorthCalculator
  #include Acropolis::Calculators::BalanceCalculator
  #include Acropolis::Calculators::LeverageCalculator

  belongs_to :trading_account
  belongs_to :latest_trade, class_name: 'Trade'
  belongs_to :exchange
  has_many :parameters, class_name: :TradingSummaryParameter

  scope :on_trading_date, -> (day) { where(trading_date: (day.beginning_of_day..day.end_of_day))}
  scope :belongs_to_exchange, -> (exchange_id) { where(TradingSummary.arel_table[:exchange_id].eq(exchange_id))}
  scope :belongs_to_trading_account, -> (trading_account_id) { where(trading_account_id: trading_account_id)}
  scope :before_trading_date, -> (date) { where(TradingSummary.arel_table[:trading_date].lteq(date))}






  def update_trade(trade)
    rest_volume = trade.traded_volume
    TradingSummary.transaction do
      trade.available_open_trades.each do |open_trade|
        close_volume = open_trade.close_position_with(trade)

        # return margin
        margin = position_close_margin(open_trade, close_volume)
        self.balance += margin

        profit = position_close_profit(open_trade, trade, close_volume)
        update_profit profit

        rest_volume -= close_volume
        break if rest_volume == 0
      end
      update_trading_fee trade.trading_fee
      self.balance -= trade.margin
      save!
    end
  end

  class << self
    def update_trade(trade)
      ts = latest_for trade
      ts = create_summary_for(trade) unless ts
      ts.update_trade trade
    end

    def create_summary_for(trade)
      latest_ts = latest(trade.trading_account_id, trade.exchange_traded_at, trade.exchange)
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

    def fetch_summaries(account_id, exchange_id = nil, date = nil)
      date = Time.now unless date
      if exchange_id
        belongs_to_trading_account(account_id)
          .belongs_to_exchange(exchange_id)
          .on_trading_date(date)
          .to_a
      else
        exchanges = Set.new
        summaries = belongs_to_trading_account(account_id)
                    .on_trading_date(date)
                    .order(updated_at: :desc )
        summaries.select do |s|
          if exchanges.include? s.exchange_id
            false
          else exchanges.include? s.exchange_id
            exchanges << s.exchange_id
            true
          end
        end
      end
    end

    def build_query_condition(account_id, date, exchange_id)
      conditions = build_query_condition_by_date(account_id, date, exchange_id)
      conditions = conditions.and(arel_table[:exchange_id].eq(exchange_id)) if exchange_id
      conditions.and(arel_table[:trading_account_id].eq(account_id))
    end

    def build_query_condition_by_date(account_id, date, exchange_id)
      conditions = nil
      if date
        latest_trading_date = latest_trading_date(account_id, date, exchange_id)
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

    def latest_for(trade)
      return nil unless trade.trading_account_id
      belongs_to_trading_account(trade.trading_account_id)
      .on_trading_date(trade.exchange_traded_at)
      .belongs_to_exchange(trade.exchange_id)
      .order(updated_at: :desc).first
    end

    def latest(trading_account_id, date, exchange_id)
      return nil unless trading_account_id
      summaries = belongs_to_trading_account(trading_account_id)
      summaries.before_trading_date(date) if date
      summaries.belongs_to_exchange(exchange_id) if exchange_id
      summaries.order(updated_at: :desc).first
    end

    def latest_trading_date(trading_account_id, date, exchange_id)
      rec = latest(trading_account_id, date, exchange_id)
      rec ? rec.trading_date : nil
    end
  end

  def open_trades
    Trade.open
        .not_been_closed
        .belongs_to_trading_account(trading_account_id)
        .belongs_to_exchange(exchange_id)
  end

  def get_parameter_resource(name, default_value)
    TradingSummaryParameter.find_by_trading_summary_id_and_parameter_name(id,
      name) || TradingSummaryParameter.create(trading_summary_id: id,
        parameter_name: name, parameter_value: default_value)
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

  def set_parameter(name, value = nil)
    value ||= 0
    parameter = get_parameter_resource(name, value)
    parameter.update({parameter_value: value})
  end

  def get_parameter(name, default_value = nil)
    default_value ||= 0
    parameter = get_parameter_resource(name, default_value)
    parameter.parameter_value
  end

  def reset_parameter(name, default_value = nil)
    default_value ||= 0
    set_parameter(name, default_value)
  end

  PARAMETER_NAMES = %w(profit trading_fee balance budget capital)
  PARAMETER_NAMES.each do |method_name|
    define_method(method_name) do
      self.send(:get_parameter, method_name.to_sym, 0)
    end

    define_method("#{method_name}=") do |val|
      self.send(:set_parameter, method_name.to_sym, val)
    end

    define_method("reset_#{method_name}") do
      self.send(:reset_parameter, method_name.to_sym)
    end
  end

  %w[exposure position_cost margin].each do |param|
    define_method(param) do
      open_trades.inject(0) {|sum, t| sum += t.send(param.to_sym)}
    end
  end

  def customer_benefit
    balance + margin
  end

  def net_worth
    capital == 0 ? 1 : customer_benefit.fdiv(capital)
  end

  def leverage
    capital == 0 ? 0 : position_cost.fdiv(capital)
  end


private

  def position_close_margin(open_trade, close_volume)
    open_trade.calc_margin(open_trade.market_price, close_volume)
  end

  def position_close_profit(open_trade, close_trade, close_volume)
    profit = (close_trade.traded_price - open_trade.traded_price) * close_volume
    profit *= -1 if close_trade.is_buy?
    profit
  end

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