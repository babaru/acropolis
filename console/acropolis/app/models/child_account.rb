class ChildAccount < ActiveRecord::Base
  belongs_to :trading_account

  def update(trade)
    rest_volume = trade.traded_volume
    trade.available_open_trades.each do |open_trade|
      close_volume = open_trade.close_position_with(trade)
      profit = (trade.traded_price - open_trade.traded_price) * close_volume
      profit *= -1 if trade.is_buy?
      self.profit += profit
      self.balance += profit

      rest_volume -= close_volume
      break if rest_volume == 0
    end
    self.profit -= trade.trading_fee
    self.balance -= trade.trading_fee
    save!
  end
  # capital, balance, profit
  def customer_benefit
    balance + margin + position_profit
  end

  def exposure
    open_trades.inject(0) { |sum, t| sum += t.instrument.market_price.price * t.open_volume }
  end

  def position_cost
    open_trades.inject(0) { |sum, t| sum += t.traded_price * t.open_volume }
  end

  def position_profit
    sum = 0
    open_trades.each do |trade|
      market_price = trade.instrument.market_price.price
      expected_trading_fee = trade.expected_trading_fee(market_price)
      profit = (market_price - trade.traded_price) * trade.open_volume - expected_trading_fee
      profit *= -1 if trade.is_sell?
      sum += profit
    end
    sum
  end

  def open_trades
    Trade.open
        .not_been_closed
        .belongs_to_trading_account(trading_account_id)
        .belongs_to_exchange(exchange_id)
  end

  def close_position(trade, open_trade_id, close_volume)
    return if trade.is_open?
    trade.record_closed(open_trade_id, close_volume)
  end

  def margin
    0
  end
end