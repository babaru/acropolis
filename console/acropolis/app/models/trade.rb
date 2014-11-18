class Trade < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :trading_account
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
  scope :side, ->(side) { where(order_side: side) }

  scope :not_later, ->(time) { where('traded_at <= ?', time)}

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

  def is_buy?
    order_side == Acropolis::OrderSides.order_sides.buy
  end

  def is_sell?
    order_side == Acropolis::OrderSides.order_sides.sell
  end

  def self.reset_all_open_volumes
    Trade.update_all('open_volume = trade_volume')
    PositionCloseRecord.delete_all
  end

  def adjust_open_volume
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

          unless PositionCloseRecord.exists?(open_trade_id: trade.id, close_trade_id: self.id)
            close_record = PositionCloseRecord.create(open_trade_id: trade.id, close_trade_id: self.id, close_volume: close_volume)
          end
        end

        if trade.open_volume > rest_volume
          close_volume = rest_volume
          trade.open_volume -= close_volume
          rest_volume = 0
          trade.save

          unless PositionCloseRecord.exists?(open_trade_id: trade.id, close_trade_id: self.id)
            close_record = PositionCloseRecord.create(open_trade_id: trade.id, close_trade_id: self.id, close_volume: close_volume)
          end
        end

        break if rest_volume == 0
      end
    end

    self.trading_account.refresh_trading_summary
  end

end
