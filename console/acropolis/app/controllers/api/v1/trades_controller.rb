module Api
  module V1

    class TradesController < BaseController

      def create

        if trade_params[:trading_account_id].nil?
          @trading_account = TradingAccount.find_by_account_no(trade_params[:trading_account_no])
        else
          @trading_account = TradingAccount.find(trade_params[:trading_account_id])
        end

        if trade_params[:exchange_id].nil?
          @exchange = Exchange.find_by_name(trade_params[:exchange_name])
        else
          @exchange = Exchange.find(trade_params[:exchange_id])
        end

        if trade_params[:instrument_id].nil?
          @instrument = Instrument.where(exchange_id: @exchange.id, security_code: trade_params[:security_code]).first
        else
          @instrument = Instrument.find(trade_params[:instrument_id])
        end

        @trade = Trade.new(trade_params)
        @trade.instrument = @instrument
        @trade.trading_account = @trading_account
        @trade.exchange = @exchange

        @trade.open_volume = trade_params[:trade_volume] if @trade.is_open?

        if trade_params[:traded_at].nil?
          @trade.traded_at = Time.now
        end

        if @trade.save
          render json: @trade, status: :created
          @trade.trading_account.calculate_trading_summary
        else
          render json: @trade.errors, status: :unprocessable_entity
        end
      end

      private

      def trade_params
        params.require(:trade).permit(
          :instrument_id,
          :security_code,
          :exchange_id,
          :exchange_name,
          :trade_price,
          :order_side,
          :trading_account_id,
          :trading_account_no,
          :traded_at,
          :trade_volume,
          :open_close,
          )
      end

      def query_params
        params.permit(:id, :trading_account_id)
      end

    end

  end
end
