module Acropolis
  module Calculators
    module NetWorthCalculator

      def calculate_net_worth
        self.net_worth = customer_benefit.fdiv(capital) if capital > 0
      end

    end
  end
end