class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :edit, :update, :destroy]

  # GET /trades
  # GET /trades.json
  def index
    @trades_grid = initialize_grid(Trade.all)
  end

  # GET /trades/1
  # GET /trades/1.json
  def show
  end

  # GET /trades/new
  def new
    @trade = Trade.new
  end

  # GET /trades/1/edit
  def edit
  end

  # POST /trades
  # POST /trades.json
  def create
    Trade.transaction do
      @trade = Trade.new(trade_params)
      @trade.save!
    end

    respond_to do |format|
      set_trades_grid
      format.html { redirect_to @trade, notice: 'Trade was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /trades/1
  # PATCH/PUT /trades/1.json
  def update
    Trade.transaction do
      @trade.update!(trade_params)
    end

    respond_to do |format|
      set_trades_grid
      format.html { redirect_to @trade, notice: 'Trade was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @trade = Trade.find(params[:trade_id])
  end

  # DELETE /trades/1
  # DELETE /trades/1.json
  def destroy
    @trade.destroy!

    respond_to do |format|
      set_trades_grid
      format.html { redirect_to trades_url, notice: 'Trade was successfully destroyed.' }
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
    def set_trade
      @trade = Trade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trade_params
      params.require(:trade).permit(
        :instrument_id,
        :traded_price,
        :order_side,
        :order_price,
        :trading_account_id,
        :traded_at,
        :traded_volume,
        :open_volume,
        :open_close,
        :exchange_id,
        :exchange_traded_at,
        :system_trade_sequence_number
        )
    end

    def set_trades_grid
      @trades_grid = initialize_grid(Trade)
    end
end

