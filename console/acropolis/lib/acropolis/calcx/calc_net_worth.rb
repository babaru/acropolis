module Acropolis
  module Calcx
    class NetWorthCalculator
      def calc(trade)
        position_profit = 0
        rest_volume = trade.is_close? ? trade.traded_volume : 0
        Trade.transaction do
          trade.available_open_trades.each do |ot|
            if rest_volume > 0
              closed_volume = ot.close_position_with(trade)
              rest_volume -= closed_volume
            else
              position_profit += ot.market_profit
            end
          end
          trade.trading_account.balance -= trade.trading_fee
        end

        profit = trade.trading_account.profit + position_profit - trade.trading_fee
        customer_benefit = trade.trading_account.capital + profit
        net_worth = customer_benefit.fdiv(trade.trading_account.capital)
      end
    end
  end
end