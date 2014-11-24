class ExchangesController < ApplicationController
  before_action :set_exchange, only: [:show, :edit, :update, :destroy]

  # GET /exchanges
  # GET /exchanges.json
  def index
    @exchanges_grid = initialize_grid(Exchange.all)
  end

  # GET /exchanges/1
  # GET /exchanges/1.json
  def show
    cache_recent_item(:exchange, @exchange.id, @exchange.name)

    @trading_symbols_grid = initialize_grid(TradingSymbol.where(exchange_id: @exchange.id))
  end

  # GET /exchanges/new
  def new
    @exchange = Exchange.new
  end

  # GET /exchanges/1/edit
  def edit
  end

  # POST /exchanges
  # POST /exchanges.json
  def create
    Exchange.transaction do
      @exchange = Exchange.new(exchange_params)
      @exchange.save!
    end

    respond_to do |format|
      set_exchanges_grid
      format.html { redirect_to @exchange, notice: 'Exchange was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /exchanges/1
  # PATCH/PUT /exchanges/1.json
  def update
    Exchange.transaction do
      @exchange.update!(exchange_params)
    end

    respond_to do |format|
      set_exchanges_grid
      format.html { redirect_to @exchange, notice: 'Exchange was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @exchange = Exchange.find(params[:exchange_id])
  end

  # DELETE /exchanges/1
  # DELETE /exchanges/1.json
  def destroy
    @exchange.destroy!

    respond_to do |format|
      set_exchanges_grid
      format.html { redirect_to exchanges_url, notice: 'Exchange was successfully destroyed.' }
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :delete }
      format.js { render :delete }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exchange
      @exchange = Exchange.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exchange_params
      params.require(:exchange).permit(
        :name,
        :type,
        :full_cn_name,
        :short_cn_name,
        :full_en_name,
        :short_en_name,
        :currency_unit
        )
    end

    def set_exchanges_grid
      @exchanges_grid = initialize_grid(Exchange)
    end
end

