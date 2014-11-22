module Api
  module V1
    class MarketPricesController < ApplicationController

      def create
        @market_price = MarketPrice.new(market_price_params)

        if market_price_params[:instrument_id].nil?
          @instrument = Instrument.where(exchange_id: @exchange.id, symbol_id: market_price_params[:symbol_id]).first
          @market_price.instrument = @instrument
        end

        if @market_price.save
          render json: @market_price, status: :created
        else
          render json: @market_price.errors, status: :unprocessable_entity
        end
      end

      private

      def market_price_params
        params.require(:market_price).permit(
          :instrument_id,
          :symbol_id,
          :price
          )
      end

      def query_params
        params.permit(:id, :instrument_id)
      end

    end
  end
end
