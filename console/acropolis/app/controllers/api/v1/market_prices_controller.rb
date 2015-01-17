module Api
  module V1
    class MarketPricesController < ApplicationController

      def create
        if market_price_params[:instrument_id].nil?
          @instrument = Instrument.where(exchange_instrument_code: market_price_params[:exchange_instrument_code]).first
        else
          @instrument = Instrument.find(market_price_params[:instrument_id])
        end

        @exchange_updated_at = Time.at(market_price_params[:price_updated_at].to_i)

        @market_price = MarketPrice.where(instrument_id: @instrument.id).first
        if @market_price.nil?
          @market_price = MarketPrice.new(market_price_params)
          @market_price.instrument = @instrument
          @market_price.exchange = @instrument.exchange
          @market_price.exchange_instrument_code = @instrument.exchange_instrument_code
          @market_price.exchange_code = @instrument.exchange.trading_code
          @market_price.exchange_updated_at = @exchange_updated_at
        else
          @market_price.price = market_price_params[:price]
          @market_price.instrument = @instrument
          @market_price.exchange = @instrument.exchange
          @market_price.exchange_instrument_code = @instrument.exchange_instrument_code
          @market_price.exchange_code = @instrument.exchange.trading_code
          @market_price.exchange_updated_at = @exchange_updated_at
        end

        if @market_price.save
          render :show
        else
          render json: @market_price.errors, status: :unprocessable_entity
        end
      end

      private

      def market_price_params
        params.require(:market_price).permit(
          :instrument_id,
          :exchange_instrument_code,
          :exchange_id,
          :exchange_code,
          :price,
          :exchange_updated_at
          )
      end

      def query_params
        params.permit(:id, :instrument_id, :exchange_id)
      end

    end
  end
end
