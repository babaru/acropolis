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

  # Class Methods
  class << self

    def order_sides
      Acropolis::OrderSides.order_sides.map{ |k,v| [I18n.t("order_sides.#{k}"),v] }
    end

    def open_or_close
      Acropolis::TradeOpenFlags.trade_open_flags.map{ |k,v| [I18n.t("order_sides.#{k}"),v] }
    end

    def opposite_side(side)
      side == Acropolis::OrderSides.order_sides.buy ? Acropolis::OrderSides.order_sides.sell : Acropolis::OrderSides.order_sides.buy
    end

    def reset_open_volumes(trading_account, trading_date, exchange)
      Trade.transaction do
        Trade.open.where({
                             trading_account_id: trading_account.id,
                             exchange_traded_at: (trading_date.beginning_of_day..trading_date.end_of_day),
                             exchange_id: exchange.id
                         }).each do |trade|
          trade.update({open_volume: trade.traded_volume})
        end

        Trade.close.where({
                              trading_account_id: trading_account.id,
                              exchange_traded_at: (trading_date.beginning_of_day..trading_date.end_of_day),
                              exchange_id: exchange.id
                          }).each do |trade|
          PositionCloseRecord.where({close_trade_id: trade.id}).destroy_all
        end
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
  end

  def trading_summary
    TradingSummary.where({trading_account_id: trading_account.id, 
                        exchange_id: exchange.id,
                        trading_date: exchange_traded_at.beginning_of_day
    }).first
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

  # Margin of this trade
  def margin
    is_close? ? 0 : instrument.trading_symbol.margin.calculate(self)
  end

  def calculate_trading_fee
    update(system_calculated_trading_fee: instrument.trading_symbol.trading_fee.calculate(self))
  end

  # Trading fee of this trade
  def trading_fee
    exchange_trading_fee > 0 ? exchange_trading_fee : system_calculated_trading_fee
  end

  # Position cost of this trade
  def position_cost
    return 0 if is_close?
    traded_price * open_volume * instrument_multiplier * instrument_currency_exchange_rate
  end

  # Market value of this trade
  def market_value(market_price = nil)
    price = market_price ? market_price : clearing_price
    price * open_volume * instrument_multiplier * instrument_currency_exchange_rate
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

  def close_position
    return if is_open?

    Trade.transaction do
      rest_volume = traded_volume
      available_open_trades.each do |trade|
        close_volume = trade.open_volume < rest_volume ? trade.open_volume : rest_volume
        trade.update!(open_volume: trade.open_volume - close_volume)
        trade.record_closed(id, close_volume)
        rest_volume -= close_volume
        break if rest_volume == 0
      end
    end
  end

  def available_open_trades
    Trade.open
          .not_been_closed
          .belongs_to_trading_account(trading_account_id)
          .belongs_to_exchange(exchange_id)
          .side(Trade.opposite_side(order_side))
          .not_later(exchange_traded_at)
          .order(:exchange_traded_at)
          .reverse_order
  end

  def market_profit
    # (market value) - ()trading fee for open volumes)
    ((instrument.market_price.price - traded_price) * open_volume -
        instrument.trading_symbol.trading_fee.factor * instrument.market_price.price * open_volume) *
        instrument_multiplier * instrument_currency_exchange_rate
  end

  def close_position_with(other_trade)
    closed_volume = open_volume < other_trade.traded_volume ? open_volume : other_trade.traded_volume
    profit = (other_trade.traded_price - traded_price) * closed_volume
    profit = -1 * profit if is_sell?
    trading_account.profit += profit
    trading_account.balance += profit
    update!(open_volume: open_volume - closed_volume)
    record_closed(other_trade.id, closed_volume)
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
