module Api
  module V1

    class TradesController < BaseController

      def create
        @trade = Trade.new(trade_params)
        if trade_params[:exchange_id].nil?
          @exchange = Exchange.find_by_name(trade_params[:exchange_name])
        end

        if trade_params[:instrument_id].nil?
          @instrument = Instrument.where(exchange_id: @exchange.id, symbol_id: trade_params[:symbol_id]).first
          @trade.instrument = @instrument
        end

        @trade.open_volume = trade_params[:trade_volume] if @trade.is_open?

        if trade_params[:traded_at].nil?
          @trade.traded_at = Time.now
        end

        if @trade.save
          render json: @trade, status: :created
        else
          render json: @trade.errors, status: :unprocessable_entity
        end
      end

      private

      def trade_params
        params.require(:trade).permit(
          :instrument_id,
          :symbol_id,
          :exchange_id,
          :exchange_name,
          :trade_price,
          :order_side,
          :trading_account_id,
          :trading_account_name,
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
