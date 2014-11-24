class Trade < ActiveRecord::Base
  attr_accessor :security_code, :exchange_name, :trading_account_no

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
  scope :not_later, ->(time) { where('traded_at <= ?', time)}

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
    return 0 if self.is_close?
    self.instrument.trading_symbol.margin.calculate(self)
  end

  # Trading fee of this trade
  def trading_fee
    self.instrument.trading_symbol.trading_fee.calculate(self)
  end

  # Position cost of this trade
  def position_cost
    return 0 if self.is_close?
    self.trade_price * self.open_volume * self.instrument.trading_symbol.multiplier * self.instrument.trading_symbol.currency.exchange_rate
  end

  # Market value of this trade
  def market_value
    mp = self.instrument.latest_price
    mp ||= self.trade_price
    mp * self.open_volume * self.instrument.trading_symbol.multiplier * self.instrument.trading_symbol.currency.exchange_rate
  end

  # Profit of this trade
  def profit
    profit = 0
    if self.is_open?
      return (self.is_buy? ? 1 : -1) * (market_value - position_cost)
    else
      self.open_trade_records.each do |open_trade_record|
        price_difference = self.trade_price - open_trade_record.open_trade.trade_price
        profit += (self.is_sell? ? 1 : -1) * price_difference * open_trade_record.close_volume * self.instrument.multiplier
      end
    end
    profit * self.instrument.trading_symbol.currency.exchange_rate
  end

  # Exposure of this trade
  # ps. buy trade will be oppsitive and sell trade will be negative
  def exposure
    (self.is_buy? ? 1 : -1) * position_cost
  end

  def reset_position
    Trade.transaction do
      if self.is_open?
        self.open_volume = self.trade_volume
        self.save

        PositionCloseRecord.where(open_trade_id: self.id).update_all(close_volume: 0)
      end
    end
  end

  def close_position
    Trade.transaction do
      if self.is_close?

        rest_volume = self.trade_volume

        Trade.open
          .whose(self.trading_account_id)
          .side(Trade.opposite_side(self.order_side))
          .not_later(self.traded_at)
          .order(:traded_at)
          .reverse_order
          .each do |trade|

          if trade.open_volume <= rest_volume
            close_volume = trade.open_volume
            rest_volume -= close_volume
            trade.open_volume = 0
            trade.save

            update_close_record(trade.id, self.id, close_volume)
          end

          if trade.open_volume > rest_volume
            close_volume = rest_volume
            trade.open_volume -= close_volume
            rest_volume = 0
            trade.save

            update_close_record(trade.id, self.id, close_volume)
          end

          break if rest_volume == 0
        end
      end
    end
  end

  private

  def update_close_record(open_trade_id, close_trade_id, close_volume)
    close_record = PositionCloseRecord.where(open_trade_id: open_trade_id, close_trade_id: close_trade_id).first
    if close_record.nil?
      PositionCloseRecord.create(open_trade_id: open_trade_id, close_trade_id: close_trade_id, close_volume: close_volume)
    else
      close_record.close_volume = close_volume
      close_record.save
    end
  end
end
