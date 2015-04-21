require 'observer'
class Trade < ActiveRecord::Base
  attr_accessor :traded_at

  belongs_to :instrument
  belongs_to :trading_account
  belongs_to :exchange
  has_many :open_trade_records, class_name: 'PositionCloseRecord', dependent: :destroy, foreign_key: 'close_trade_id'
  has_many :close_trade_records, class_name: 'PositionCloseRecord', dependent: :destroy, foreign_key: 'open_trade_id'
  has_many :open_trades, through: :open_trade_records
  has_many :close_trades, through: :close_trade_records

  scope :open, -> { where(
    Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.open)
  )}
  scope :not_been_closed, ->{ where((Trade.arel_table[:open_volume]).gt(0)) }
  scope :close, -> { where(
    Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.close)
  )}
  scope :belongs_to_trading_account, ->(trading_account_id) { where(trading_account_id: trading_account_id) }
  scope :belongs_to_exchange, ->(exchange_id) { where(exchange_id: exchange_id)}
  scope :traded_on_instrument, ->(instrument_id) { where(instrument_id: instrument_id) }
  scope :side, ->(side) { where(order_side: side) }
  scope :not_later, ->(time) { where('exchange_traded_at <= ?', time)}
  scope :after, ->(sequence_number) { where(Trade.arel_table[:system_trade_sequence_number].gt(sequence_number))}
  scope :today, -> { where(Arel::Nodes::NamedFunction.new('date', [Trade.arel_table[:exchange_traded_at]]).eq(Time.zone.now.strftime('%Y-%m-%d')))}
  scope :when, ->(date){ where(Arel::Nodes::NamedFunction.new('date', [Trade.arel_table[:exchange_traded_at]]).eq(date.strftime('%Y-%m-%d')))}

  after_create :notify_new_trade

  def notify_new_trade
    Trade.add_observer(TradingSummary, :update_trade)
    Trade.changed
    Trade.notify_observers self
  end
  # Class Methods
  class << self
    include Observable

    def order_sides
      Acropolis::OrderSides.order_sides.map{ |k,v| [I18n.t("order_sides.#{k}"),v] }
    end

    def open_or_close
      Acropolis::TradeOpenFlags.trade_open_flags.map{ |k,v| [I18n.t("trade_open_flags.#{k}"),v] }
    end

    def opposite_side(side)
      side == Acropolis::OrderSides.order_sides.buy ? Acropolis::OrderSides.order_sides.sell : Acropolis::OrderSides.order_sides.buy
    end

    def reset_open_volumes(trading_account_id, exchange_id, trading_date)
      Trade.transaction do
        Trade.open
            .belongs_to_trading_account(trading_account_id)
            .belongs_to_exchange(exchange_id)
            .when(trading_date)
            .each {|t| t.update(open_volume: t.traded_volume)}
        Trade.close
            .belongs_to_trading_account(trading_account_id)
            .belongs_to_exchange(exchange_id)
            .when(trading_date)
            .each {|t| PositionCloseRecord.destroy_records(t.id)}
        end
    end

    def waiting_trades_for(trading_account_id, trading_date, exchange_id, last_seq_no)
      self.when(trading_date)
          .belongs_to_trading_account(trading_account_id)
          .belongs_to_exchange(exchange_id)
          .after(last_seq_no)
          .order(:system_trade_sequence_number)
    end

    def trades_for(trading_account_id, trading_date, exchange_id)
      self.when(trading_date)
          .belongs_to_trading_account(trading_account_id)
          .belongs_to_exchange(exchange_id)
          .order(:exchange_traded_at)
    end

    def last_trade_seq_no
      Trade.last ? Trade.last.system_trade_sequence_number : 0
    end
  end

  def trading_summary
    TradingSummary.belongs_to_trading_account(trading_account.id)
        .belongs_to_exchange(exchange.id)
        .on_trading_date(exchange_traded_at)
        .first
  end

  def is_open?
    open_close == Acropolis::TradeOpenFlags.trade_open_flags.open
  end

  def is_close?
    open_close == Acropolis::TradeOpenFlags.trade_open_flags.close
  end

  def is_buy?
    order_side == Acropolis::OrderSides.order_sides.buy
  end

  def is_sell?
    order_side == Acropolis::OrderSides.order_sides.sell
  end

  def market_price
    self.instrument.market_price.price
  end

  def open_price
    return traded_price if is_open?
    # if it's a close trade, calculate average open price of corresponding open trade(s)
    sum_traded_volume = sum_traded_value = 0
    open_trade_records.each do |rec|
      sum_traded_volume += rec.close_volume
      sum_traded_value += (rec.close_volume * rec.open_trade.traded_price)
    end
    sum_traded_volume > 0 ? sum_traded_value.fdiv(sum_traded_volume) : 0
  end

  def close_price
    # If it's an open trade, calculate average close price of corresponding close trade(s).
    sum_traded_volume = sum_traded_value = 0
    close_trade_records.each do |rec|
      sum_traded_volume += rec.close_volume
      sum_traded_value += (rec.close_volume * rec.close_trade.traded_price)
    end
    sum_traded_volume > 0 ? sum_traded_value.fdiv(sum_traded_volume) : 0
  end

  def calc_close_profit(close_price, close_volume)
    profit = (close_price - traded_price) * close_volume * instrument_multiplier * instrument_currency_exchange_rate
    profit *= -1 if is_sell?
    profit
  end

  def calc_margin(price = nil, volume = nil)
    is_close? ? 0 : instrument.trading_symbol.margin.calculate(self, price, volume)
  end

  # Margin of this trade
  def margin
    calc_margin
  end

  def calc_trading_fee(price = nil, volume = nil)
    instrument.trading_symbol.trading_fee.calculate(self, price, volume)
  end

  def trading_fee
    return exchange_trading_fee if exchange_trading_fee > 0
    if system_calculated_trading_fee.nil? || system_calculated_trading_fee == 0.0
      update(system_calculated_trading_fee: calc_trading_fee)
    end
    system_calculated_trading_fee
  end

  # Position cost of this trade
  def position_cost
    return 0 if is_close?
    traded_price * open_volume * instrument_multiplier * instrument_currency_exchange_rate
  end

  # Market value of this trade
  def market_value
    market_price * open_volume * instrument_multiplier * instrument_currency_exchange_rate
  end

  # Profit of this trade
  def profit
    profit = 0
    if is_open?
      if market_value != position_cost
        return (is_buy? ? 1 : -1) * (market_value - position_cost)
      end
    else
      open_trade_records.each do |rec|
        price_difference = traded_price - rec.open_trade.traded_price
        profit += (is_sell? ? 1 : -1) * price_difference * rec.close_volume * instrument_multiplier * instrument_currency_exchange_rate
      end
    end
    profit
  end

  # Exposure of this trade
  # ps. buy trade will be positive and sell trade will be negative
  def exposure
    market_value
  end

  def clearing_price
    instrument_clearing_price = self.instrument.clearing_price(exchange_traded_at.beginning_of_day)
    return instrument_clearing_price if instrument_clearing_price > 0
    return close_price if self.is_open? && self.open_volume == 0
    0
  end

  def available_open_trades
    Trade.open
          .not_been_closed
          .belongs_to_trading_account(trading_account_id)
          .belongs_to_exchange(exchange_id)
          .side(Trade.opposite_side(order_side))
          .traded_on_instrument(instrument_id)
          .not_later(exchange_traded_at)
          .order(:exchange_traded_at)
          .reverse_order
  end

  def close_position(close_trade)
    closed_volume = open_volume < close_trade.traded_volume ? open_volume : close_trade.traded_volume
    update!(open_volume: open_volume - closed_volume)
    record_closed(close_trade.id, closed_volume)
    closed_volume
  end

  def record_closed(close_trade_id, volume)
    rec = PositionCloseRecord.where(open_trade_id: id, close_trade_id: close_trade_id).first
    if rec
      rec.close_volume += volume
      rec.save
    else
      rec = PositionCloseRecord.create(open_trade_id: id, close_trade_id: close_trade_id, close_volume: volume)
    end
    rec
  end

  def instrument_multiplier
    instrument.trading_symbol.multiplier
  end

  def instrument_currency_exchange_rate
    instrument.trading_symbol.currency.exchange_rate
  end
end
