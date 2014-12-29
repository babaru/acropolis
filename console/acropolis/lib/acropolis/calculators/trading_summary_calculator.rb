module Acropolis
  module Calculators

    module TradingSummaryCalculator

      def calculate

        unhandled_trades(Time.now).each do |trade|
          trade.close_position

          calculate_profit(trade)
          calculate_position_cost(trade)
          calculate_trading_fee(trade)
          calculate_margin(trade)
          calculate_exposure(trade)

          self.latest_trade = trade

          trading_account.calculate_trading_summary_after_trade(trade)
        end

        self.save

      end

      def unhandled_trades(date)
        Trade.when(date).after(latest_trade.system_trade_sequence_number)
      end

      private

      def calculate_profit(trade)
        self.profit += trade.profit
      end

      def calculate_position_cost(trade)
        self.position_cost += trade.position_cost
      end

      def calculate_trading_fee(trade)
        self.trading_fee += trade.trading_fee
      end

      def calculate_margin(trade)
        self.margin += trade.margin
      end

      def calculate_exposure(trade)
        self.exposure += trade.exposure
      end

    end

  end
end