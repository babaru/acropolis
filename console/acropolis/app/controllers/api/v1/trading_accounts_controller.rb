module Api
  module V1

    class TradingAccountsController < BaseController

      #
      # Auth trading account, 0 for success, 1 for password incorrect,
      # 2 for account_no not found, -1 for invalid request
      #
      def auth
        if params[:account_no] && params[:password]
          trading_account = TradingAccount.find_by_account_no(params[:account_no])
          if trading_account
            if trading_account.password == params[:password]
              render json: {status: 0}
            else
              render json: {status: 1}
            end
          else
            render json: {status: 2}
          end
        else
          render json: {status: -1}
        end
      end

      private

        def trading_account_params
          params.require(:trading_account).permit(
            :name,
            :account_no,
            :password,
            :product_id
          )
        end

        def query_params
          params.permit(:id, :name, :product_id)
        end

    end

  end
end
