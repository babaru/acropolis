module Acropolis
  module Calculators
    module LeverageCalculator

      def calculate_leverage
        self.leverage = position_cost.fdiv(capital) if capital > 0
      end

    end
  end
end