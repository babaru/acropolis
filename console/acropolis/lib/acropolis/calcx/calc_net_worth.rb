module Acropolis
  module Calcx
    class NetWorthCalculator
      def calc(trade)
        profit = 0
        rest_volume = trade.is_close? ? trade.traded_volume : 0
        trade.available_open_trades.each do |ot|
          if rest_volume > 0
            closed_volume = ot.close_position_with(trade)
            rest_volume -= closed_volume
          else
            profit += ot.market_profit
          end
        end

        trade.account.balance -= trade.trading_fee
        profit = trade.account.profit + profit - trade.trading_fee
        customer_benefit = trade.account.capital + profit
        net_worth = customer_benefit.fdiv(trade.account.capital)
      end
    end
  end
end