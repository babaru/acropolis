module Api
  module V1

    class TradingAccountsController < BaseController

      #
      # Auth trading account, 0 for success, 1 for password incorrect,
      # 2 for account_no not found, -1 for invalid request
      #
      def auth
        @rsp = {}
        if params[:account_no] && params[:password]
          @trading_account = TradingAccount.find_by_account_no(params[:account_no])
          if @trading_account
            if @trading_account.password == params[:password]
              @rsp = {status: 0, trading_account: @trading_account}
              render json: @rsp
            else
              @rsp = {status: 1}
              render json: @rsp
            end
          else
            @rsp = {status: 2}
            render json: @rsp
          end
        else
          @rsp = {status: -1}
          render json: @rsp
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
