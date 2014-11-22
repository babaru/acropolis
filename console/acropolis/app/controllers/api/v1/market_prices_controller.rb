module Api
  module V1
    class MarketPricesController < ApplicationController

      def create
        if market_price_params[:exchange_id].nil?
          @exchange = Exchange.find_by_name(market_price_params[:exchange_name])
        else
          @exchange = Exchange.find(market_price_params[:exchange_id])
        end

        if market_price_params[:instrument_id].nil?
          @instrument = Instrument.where(exchange_id: @exchange.id, symbol_id: market_price_params[:symbol_id]).first
        else
          @instrument = Instrument.find(market_price_params[:instrument_id])
        end

        @market_price = MarketPrice.where(instrument_id: @instrument.id).first
        if @market_price.nil?
          @market_price = MarketPrice.new(market_price_params)
          @market_price.instrument = @instrument
          @market_price.exchange = @exchange
        else
          @market_price.price = market_price_params[:price]
        end

        if @market_price.save
          render json: @market_price, status: :created
          TradingAccount.all.each { |trader| trader.calculate_trading_summary }
        else
          render json: @market_price.errors, status: :unprocessable_entity
        end
      end

      private

      def market_price_params
        params.require(:market_price).permit(
          :instrument_id,
          :symbol_id,
          :exchange_id,
          :exchange_name,
          :price
          )
      end

      def query_params
        params.permit(:id, :instrument_id, :exchange_id)
      end

    end
  end
end
