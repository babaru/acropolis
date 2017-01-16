module Acropolis
  module Calculators
    module CustomerBenefitCalculator

      def calculate_customer_benefit
        self.customer_benefit = capital + profit - trading_fee
      end

    end
  end
end