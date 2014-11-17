module Acropolis
  module Calculators

    class CustomerBenefitCalculator

      def initialize()

      end

      def calculate(data = {})
        @initial_capital = data[:initial_capital]
        @open_trades = data[:open_trades]
        @close_trades = data[:close_trades]

        total_open_profit = @open_trades.inject(0) do |sum, open_trade|
          open_profit = (open_trade[:side] == :buy ? 1 : -1) * (open_trade[:market_price] - open_trade[:price]) * open_trade[:lot_size]
          sum += open_profit
        end

        total_close_profit = @close_trades.inject(0) do |sum, close_trade|
          close_profit = (close_trade[:sold_at] - close_trade[:bought_at]) * close_trade[:lot_size]
          sum += close_profit
        end

        return @initial_capital + total_open_profit + total_close_profit - data[:trading_fee]
      end

    end

  end
end