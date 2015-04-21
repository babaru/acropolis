require 'observer'
class ChildAccount < ActiveRecord::Base
  belongs_to :trading_account

  scope :belongs_to_trading_account, ->(trading_account_id) {where(trading_account_id: trading_account_id )}
  scope :belongs_to_exchange, ->(exchange_id) {where(exchange_id: exchange_id)}

  class << self
    include Observable
  end

  def open_trades
    Trade.open
        .not_been_closed
        .belongs_to_trading_account(trading_account_id)
        .belongs_to_exchange(exchange_id)
  end

  def update_trade(trade)
    rest_volume = trade.traded_volume
    ChildAccount.transaction do
      trade.available_open_trades.each do |open_trade|
        close_volume = open_trade.close_position(trade)

        margin = position_close_margin(open_trade, close_volume)
        update_margin(-1 * margin)

        profit = position_close_profit(open_trade, trade, close_volume)
        update_profit profit

        rest_volume -= close_volume
        break if rest_volume == 0
      end
      update_trading_fee trade.trading_fee
      update_margin trade.margin
      self.save!
    end

    ChildAccount.changed
    ChildAccount.notify_observers self
  end

  class << self
    # update method for Observer.
    def update_trade(trade)
      ca = ChildAccount.belongs_to_trading_account(trade.trading_account_id).belongs_to_exchange(trade.exchange_id).first
      ca.update_trade(trade)
    end
  end

  %w[exposure position_cost position_expected_profit].each do |param|
    define_method(param) do
      open_trades.inject(0) {|sum, t| sum += t.send(param.to_sym)}
    end
  end

  def customer_benefit
    balance + margin + position_expected_profit
  end


private

  def position_close_profit(open_trade, close_trade, close_volume)
    profit = (close_trade.traded_price - open_trade.traded_price) * close_volume
    profit *= -1 if close_trade.is_buy?
    profit
  end

  def position_close_margin(open_trade, close_volume)
    open_trade.calc_margin(open_trade.market_price, close_volume)
  end

  def update_trading_fee(trading_fee)
    self.profit -= trading_fee
    self.balance -= trading_fee
    self.trading_fee += trading_fee
  end

  def update_profit(profit)
    self.profit += profit
    self.balance += profit
  end

  def update_margin(margin)
    self.balance -= margin
    self.margin += margin
  end
end

#Trade.add_observer(ChildAccount, :update_trade)