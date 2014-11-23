module Api
  module V1

    class TradingAccountsController < BaseController

      private

        def trading_account_params
          params.require(:trading_account).permit(
            :name,
            :account_no,
            :product_id
          )
        end

        def query_params
          params.permit(:id, :name, :product_id)
        end

    end

  end
end
