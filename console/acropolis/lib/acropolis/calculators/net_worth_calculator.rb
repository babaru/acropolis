module Acropolis
  module Calculators
    module NetWorthCalculator

      def calculate_net_worth
        self.net_worth = customer_benefit.fdiv(capital) if capital > 0
      end

      # def calculate_net_worth(trading_summaries)
      #   total_capital = calculate_capital(trading_summaries)
      #   return 0 if total_capital == 0
      #   calculate_customer_benefit(trading_summaries).fdiv(total_capital)
      # end

    end
  end
end