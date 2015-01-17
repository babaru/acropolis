module Api
  module V1

    class TradingAccountsController < BaseController

      def index
        @trading_accounts = TradingAccount.where(account_number: params[:account_number])
        respond_with @trading_accounts
      end

      private

        def trading_account_params
          params.require(:trading_account).permit(
            :name,
            :account_number,
            :password
          )
        end

        def query_params
          params.permit(:id, :name, :account_number)
        end

    end

  end
end
