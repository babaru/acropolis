module Acropolis
  module Calculators
    module BalanceCalculator

      def calculate_balance
        self.balance = capital - margin + profit - trading_fee
      end

    end
  end
end