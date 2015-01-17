module Api
  module V1

    class TradesController < BaseController

      def create
        if trade_params[:trading_account_id].nil?
          @trading_account = TradingAccount.find_by_account_number(trade_params[:trading_account_number])
        else
          @trading_account = TradingAccount.find(trade_params[:trading_account_id])
        end

        if trade_params[:instrument_id].nil?
          @instrument = Instrument.where(exchange_instrument_code: trade_params[:exchange_instrument_code]).first
        else
          @instrument = Instrument.find(trade_params[:instrument_id])
        end

        @exchange_traded_at = Time.at(trade_params[:traded_at].to_i)

        @trade = Trade.where({
          exchange_id: @instrument.exchange.id,
          instrument_id: @instrument.id,
          exchange_trade_id: trade_params[:exchange_trade_id],
          exchange_traded_at: (@exchange_traded_at.beginning_of_day..@exchange_traded_at.end_of_day)
          }).first

        if @trade.nil?
          @trade = Trade.new(trade_params)
          set_attributes

          if @trade.save
            render :show, status: :created
          else
            render json: @trade.errors, status: :unprocessable_entity
          end
        else
          set_attributes
          if @trade.update(trade_params)
            render :show
          else
            render json: get_resource.errors, status: :unprocessable_entity
          end
        end
      end

      def latest_of_exchange

        if params[:exchange_id].nil?
          @exchange = Exchange.find_by_trading_code(params[:exchange_code])
        else
          @exchange = Exchange.find(params[:exchange_id])
        end

        exchange_traded_at = Time.at(params[:date].to_i)

        @trade = Trade.where({
          exchange_id: @exchange.id,
          exchange_traded_at: (exchange_traded_at.beginning_of_day..exchange_traded_at.end_of_day)
        }).order(:exchange_traded_at).reverse_order.first

        render :show
      end

      private

      def trade_params
        params.require(:trade).permit(
          :instrument_id,
          :exchange_instrument_code,
          :exchange_id,
          :exchange_code,
          :trading_account_id,
          :trading_account_number,
          :exchange_traded_at,
          :traded_at,
          :traded_price,
          :order_side,
          :traded_volume,
          :open_close,
          :exchange_trade_sequence_number,
          :exchange_trade_id,
          :exchange_margin,
          :exchange_trading_fee,
          :system_calculated_margin,
          :system_calculated_trading_fee,
          :system_trade_sequence_number,
          )
      end

      def query_params
        params.permit(:id, :trading_account_id)
      end

      def set_attributes
        @trade.exchange_traded_at = @exchange_traded_at
        @trade.instrument = @instrument
        @trade.exchange_instrument_code = @instrument.exchange_instrument_code
        @trade.trading_account = @trading_account
        @trade.trading_account_number = @trading_account.account_number
        @trade.exchange = @instrument.exchange
        @trade.exchange_code = @instrument.exchange.trading_code
        logger.debug @trade.open_close
        @trade.open_volume = trade_params[:traded_volume] if @trade.is_open?
        @trade.system_calculated_margin = @trading_account.client.margin(@trade) if @trade.is_open?
        @trade.system_calculated_trading_fee = @trading_account.client.trading_fee(@trade)
        @instrument.exchange.generate_trade_sequence_number(@trade)
      end

    end

  end
end
