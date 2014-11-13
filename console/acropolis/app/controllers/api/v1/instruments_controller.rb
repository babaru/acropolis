module Api
  module V1

    class Api::V1::InstrumentsController < BaseController

      def create

        @instrument = Instrument.new(instrument_params)

        @underlying = Instrument.find_by_name(instrument_params[:underlying_name]) if instrument_params[:underlying_id].nil? && !instrument_params[:underlying_name].nil?
        @instrument.underlying = @underlying

        @exchange = Exchange.find_by_name(instrument_params[:exchange_name]) if instrument_params[:exchange_id].nil? && !instrument_params[:exchange_name].nil?
        @instrument.exchange = @exchange

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
            :underlying_name,
            :underlying_id,
            :exchange_id,
            :exchange_name,
            :expiration_date,
            :strike_price
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
