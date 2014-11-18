class Trade < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :trading_account

  attr_accessor :symbol_id, :exchange_name

  after_create :adjust_open_volume

  def self.order_sides
    Acropolis::OrderSides.order_sides.map{ |k,v| [I18n.t("order_sides.#{k}"),v] }
  end

  def self.open_or_close
    Acropolis::TradeOpenFlags.trade_open_flags.map{ |k,v| [I18n.t("order_sides.#{k}"),v] }
  end

  def self.opposite_side(side)
    side == Acropolis::OrderSides.order_sides.buy ? Acropolis::OrderSides.order_sides.sell : Acropolis::OrderSides.order_sides.buy
  end

  def is_open?
    open_close == Acropolis::TradeOpenFlags.trade_open_flags.open
  end

  def is_close?
    open_close == Acropolis::TradeOpenFlags.trade_open_flags.close
  end

  private

  def adjust_open_volume
    if self.is_close?
      open_trades = Trade.select(Arel.star).where(
        Trade.arel_table[:instrument_id].eq(self.instrument_id).and(
          Trade.arel_table[:order_side].eq(Trade.opposite_side(self.order_side)).and(
            Trade.arel_table[:trading_account_id].eq(self.trading_account_id).and(
              Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.open).and(
                Trade.arel_table[:open_volume].gt(0)
              )
            )
          )
        )
      ).order(:traded_at).reverse_order

      rest_volume = self.trade_volume
      open_trades.each do |trade|
        if trade.open_volume <= rest_volume
          rest_volume -= trade.open_volume
          trade.open_volume = 0
          trade.save
        end

        if trade.open_volume > rest_volume
          trade.open_volume -= rest_volume
          rest_volume = 0
          trade.save
        end

        break if rest_volume == 0
      end
    end
  end

  def refresh_positions_by_side(side)
    open_trades = Trade.where({

      instrument_id:      instrument_id,
      order_side:         side,
      trading_account_id: trading_account_id,
      open_close:         Acropolis::TradeOpenFlags.trade_open_flags.open

      }).order('traded_at asc')

    open_volume = open_trades.sum('trade_volume')
    close_volume = Trade.where({

      instrument_id:      instrument_id,
      order_side:         side == Acropolis::OrderSides.order_sides.buy ? Acropolis::OrderSides.order_sides.sell : Acropolis::OrderSides.order_sides.buy,
      trading_account_id: trading_account_id,
      open_close:         Acropolis::TradeOpenFlags.trade_open_flags.close

      }).sum('trade_volume')

    find_out_position_trades(open_trades, open_volume - close_volume).map do |trade_price, volume|
      if volume > 0
        Position.create({
          instrument_id:      instrument_id,
          trading_account_id: trading_account_id,
          trade_price:        trade_price,
          volume:             volume,
          order_side:         side
          })
      end
    end

  end

  def refresh_positions
    Position.where({
      instrument_id:      instrument_id,
      trading_account_id: trading_account_id
      }).delete_all

    refresh_positions_by_side(Acropolis::OrderSides.order_sides.buy)
    refresh_positions_by_side(Acropolis::OrderSides.order_sides.sell)
  end

  def find_out_position_trades(open_trades, rest_volume)
    position_trades = {}
    open_trades.each do |trade|
      if trade.trade_volume <= rest_volume
        position_trades[trade.trade_price] ||= 0
        position_trades[trade.trade_price] += trade.trade_volume
        rest_volume -= trade.trade_volume
      else
        position_trades[trade.trade_price] ||= 0
        position_trades[trade.trade_price] += rest_volume
        rest_volume = 0
      end

      break if rest_volume == 0
    end
    position_trades
  end
end
