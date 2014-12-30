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
  scope :close, -> { where(
    Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.close)
  )}
  scope :whose, ->(trading_account_id) { where(trading_account_id: trading_account_id) }
  scope :which, ->(instrument_id) { where(instrument_id: instrument_id) }
  scope :side, ->(side) { where(order_side: side) }
  scope :not_later, ->(time) { where('exchange_traded_at <= ?', time)}
  scope :after, ->(sequence_number) { where(Trade.arel_table[:system_trade_sequence_number].gteq(sequence_number))}
  scope :today, -> { where(Arel::Nodes::NamedFunction.new('date', [Trade.arel_table[:exchange_traded_at]]).eq(Time.now.strftime('%Y-%m-%d')))}
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

    def reset_position(trading_account)
      Trade.transaction do
        Trade.connection.execute("UPDATE trades SET open_volume = traded_volume WHERE open_close = #{Acropolis::TradeOpenFlags.trade_open_flags.open} AND trading_account_id = #{trading_account.id}")

        PositionCloseRecord.where(PositionCloseRecord.arel_table[:close_trade_id].in(
          Trade.select(:id).where(Trade.arel_table[:trading_account_id].eq(trading_account.id).and(
            Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.close))).ast
          )
        ).delete_all

      end
    end

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

  # Margin of this trade
  def margin
    return exchange_margin if exchange_margin > 0
    system_calculated_margin
  end

  # Trading fee of this trade
  def trading_fee
    return exchange_trading_fee if exchange_trading_fee > 0
    system_calculated_trading_fee
  end

  # Position cost of this trade
  def position_cost
    return 0 if self.is_close?
    self.traded_price * self.open_volume * instrument_multiplier * instrument_currency_exchange_rate
  end

  # Market value of this trade
  def market_value
    mp = self.instrument_latest_price
    mp * self.open_volume * self.instrument_multiplier * self.instrument_currency_exchange_rate
  end

  # Profit of this trade
  def profit
    profit = 0
    if self.is_open?
      return (self.is_buy? ? 1 : -1) * (market_value - position_cost)
    else
      self.open_trade_records.each do |open_trade_record|
        price_difference = self.traded_price - open_trade_record.open_trade.traded_price
        profit += (self.is_sell? ? 1 : -1) * price_difference * open_trade_record.close_volume * self.instrument_multiplier * self.instrument_currency_exchange_rate
      end
    end
    profit
  end

  # Exposure of this trade
  # ps. buy trade will be oppsitive and sell trade will be negative
  def exposure
    market_value
  end

  def close_position
    return if is_open?

    Trade.transaction do
      rest_volume = self.traded_volume
      available_open_trades.each do |trade|
        result = calculate_close_volume(trade, rest_volume)
        find_or_create_close_record(trade, result[0])
        rest_volume = result[1]
        break if rest_volume == 0
      end
    end
  end

  def calculate_close_volume(open_trade, rest_volume)
    close_volume = 0

    if open_trade.open_volume <= rest_volume
      close_volume = open_trade.open_volume
      rest_volume -= close_volume
      open_trade.open_volume = 0
      open_trade.save
    end

    if open_trade.open_volume > rest_volume
      close_volume = rest_volume
      open_trade.open_volume -= close_volume
      rest_volume = 0
      open_trade.save
    end

    [close_volume, rest_volume]
  end

  def available_open_trades
    Trade.open
          .whose(self.trading_account_id)
          .side(Trade.opposite_side(self.order_side))
          .not_later(self.traded_at)
          .order(:traded_at)
          .reverse_order
  end

  def save_close_records(records)
    Trade.transaction do
      records.each { |record| record.save }
    end
  end

  def find_or_create_close_record(open_trade, close_volume)
    close_record = PositionCloseRecord.where(open_trade_id: open_trade.id, close_trade_id: id).first
    if close_record.nil?
      close_record = PositionCloseRecord.create(open_trade_id: open_trade.id, close_trade_id: id, close_volume: close_volume)
    else
      close_record.close_volume = close_volume
      close_record.save
    end
    return close_record
  end

  def instrument_multiplier
    instrument.multiplier
  end

  def instrument_currency_exchange_rate
    instrument.currency_exchange_rate
  end

  def instrument_latest_price
    instrument.latest_price
  end
end
