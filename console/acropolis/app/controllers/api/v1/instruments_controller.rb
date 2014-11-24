module Api
  module V1

    class Api::V1::InstrumentsController < BaseController

      def create

        @instrument = Instrument.new(instrument_params)

        if instrument_params[:exchange_id].nil?
          @exchange = Exchange.find_by_name(instrument_params[:exchange_name])
        else
          @exchange = Exchange.find(instrument_params[:exchange_id])
        end

        if instrument_params[:trading_symbol_id]
          @trading_symbol = TradingSymbol.find(instrument_params[:trading_symbol_id])
        else
          @trading_symbol = TradingSymbol.where(name: instrument_params[:symbol_id], exchange_id: @exchange.id).first
          if @trading_symbol.nil?
            @trading_symbol = TradingSymbol.create(name: instrument_params, exchange_id: @exchange.id)
          end
        end

        if instrument_params[:currency_id].nil?
          @currency = Currency.find_by_name(instrument_params[:currency_name])
        else
          @currency = Currency.find(instrument_params[:currency_id])
        end

        @instrument.trading_symbol = @trading_symbol
        @instrument.exchange = @exchange
        @instrument.currency = @currency

        if @instrument.save
          render :show, status: :created
        else
          render json: @instrument.errors, status: :unprocessable_entity
        end

      end

      private

        def instrument_params
          params.require(:instrument).permit(
            :name,
            :symbol_id,
            :type,
            :exchange_id,
            :exchange_name,
            :expiration_date,
            :strike_price,
            :currency_id,
            :currency_name,
            trading_fee_attributes: [
              :id,
              :type,
              :factor
            ],
            margin_attributes: [
              :id,
              :type,
              :factor
            ]
            )
        end

        def query_params
          params.permit(
            :id,
            :name,
            :symbol_id,
            :type,
            :underlying_id,
            :exchange_id,
            :expiration_date,
            :strike_price
            )
        end

    end

  end
end
