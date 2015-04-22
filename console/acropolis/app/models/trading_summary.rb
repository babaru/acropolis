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
  scope :before_time, ->(time) {where(TradingSummary.arel_table[:trading_date].lt(time))}

  param_accessor :profit
  param_accessor :trading_fee
  param_accessor :budget
  param_accessor :capital
  param_accessor :net_available_fund

  extend Acropolis::ParameterAggregation
  param_aggregation :exposure, from: :open_trades
  param_aggregation :position_cost, from: :open_trades
  param_aggregation :margin, from: :open_trades
  param_aggregation :market_value, from: :open_trades

  class << self
    def update_trade(trade)
      ts = latest_for(trade) || create_summary_for(trade)
      ts.update_trade trade
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

    def latest_trading_date(trading_account_id, exchange_id, date)
      rec = latest(trading_account_id, exchange_id, date)
      rec ? rec.trading_date : nil
    end
  end

  def update_trade(trade)
    rest_volume = trade.traded_volume
    TradingSummary.transaction do
      trade.available_open_trades.each do |open_trade|
        close_volume = open_trade.close_position(trade)

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
      self.latest_trade_id = trade.id
      save!
    end
  end

  def refresh_params
    update(latest_trade_id: nil)
    Trade.reset_open_volumes(trading_account.id, exchange.id, trading_date)
    reset_params(prior_summary)
    refresh_trades(prior_summary)
  end

  def latest_trade_seq_no
    latest_trade ? latest_trade.system_trade_sequence_number : 0
  end

  def mark_to_market_profit_lost
    market_value - position_cost
  end

  def available_fund
    net_available_fund + mark_to_market_profit_lost
  end

  def balance
    available_fund + margin
  end

  def customer_benefit
    balance
  end

  def net_worth
    capital == 0 ? 1 : customer_benefit.fdiv(capital)
  end

  def leverage
    capital == 0 ? 0 : position_cost.fdiv(capital)
  end

  class << self

  private

    def create_summary_for(trade)
      latest_ts = latest(trade.trading_account_id, trade.exchange.id, trade.exchange_traded_at)
      ts = TradingSummary.create(trading_account_id: trade.trading_account_id,
                                 exchange_id: trade.exchange_id,
                                 trading_date: trade.exchange_traded_at)
      reset_params(ts, latest_ts)
      ts
    end

    def reset_params(ts, latest_ts)
      raise 'prior trading summary not found' unless latest_ts

      if latest_ts.trading_date.beginning_of_day != ts.trading_date.beginning_of_day
        ts.profit = 0
        ts.trading_fee = 0
      else
        ts.profit = latest_ts.profit
        ts.trading_fee = latest_ts.trading_fee
      end

      ts.budget = latest_ts.budget
      ts.capital = latest_ts.capital
      ts.net_available_fund = latest_ts.net_available_fund
      ts.save!
    end

    def latest_for(trade)
      return nil unless trade.trading_account_id
      belongs_to_trading_account(trade.trading_account_id)
          .on_trading_date(trade.exchange_traded_at)
          .belongs_to_exchange(trade.exchange_id)
          .order(updated_at: :desc)
          .first
    end

    def latest(trading_account_id, exchange_id, date)
      return nil unless trading_account_id
      summaries = belongs_to_trading_account(trading_account_id)
      summaries = summaries.belongs_to_exchange(exchange_id) if exchange_id
      summaries = summaries.before_trading_date(date) if date
      summaries.order(updated_at: :desc).first
    end
  end

private

  def open_trades
    Trade.open
        .not_been_closed
        .belongs_to_trading_account(trading_account_id)
        .belongs_to_exchange(exchange_id)
  end

  def prior_summary
    TradingSummary.belongs_to_trading_account(trading_account.id)
        .belongs_to_exchange(exchange.id)
        .before_time(trading_date)
        .order(created_at: :desc)
        .first
  end

  def trades_after(summary)
    Trade.belongs_to_trading_account(trading_account.id)
        .belongs_to_exchange(exchange.id)
        .after(summary.latest_trade_seq_no)
        .order(:system_trade_sequence_number)
  end

  def reset_params(prior_summary)
    TradingSummary.send(:reset_params, self, prior_summary)
  end

  def refresh_trades(prior_ts)
    trades_after(prior_ts).each {|t| update_trade(t) }
  end

  def update_trading_fee(_trading_fee)
    self.net_available_fund = self.net_available_fund - _trading_fee
    self.trading_fee = self.trading_fee + _trading_fee
  end

  def update_profit(_profit)
    self.profit = self.profit + _profit
    self.net_available_fund = self.net_available_fund + _profit
  end

  def update_margin(_margin)
    self.net_available_fund = self.net_available_fund - _margin
  end
end

#Trade.add_observer(TradingSummary, :update_trade)

