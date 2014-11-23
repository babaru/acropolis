class TradingAccountInstrumentsController < ApplicationController
  before_action :set_trading_account_instrument, only: [:show, :edit, :update, :destroy]
  before_action :set_trading_account, only: [:new]

  # GET /trading_account_instruments
  # GET /trading_account_instruments.json
  def index
    @trading_account_instruments_grid = initialize_grid(TradingAccountInstrument.all)
  end

  # GET /trading_account_instruments/1
  # GET /trading_account_instruments/1.json
  def show
  end

  # GET /trading_account_instruments/new
  def new
    @trading_account_instrument = TradingAccountInstrument.new
    @trading_account_instrument.trading_account = @trading_account
  end

  # GET /trading_account_instruments/1/edit
  def edit
  end

  # POST /trading_account_instruments
  # POST /trading_account_instruments.json
  def create
    TradingAccountInstrument.transaction do
      @trading_account_instrument = TradingAccountInstrument.new(trading_account_instrument_params)
      @trading_account_instrument.save!
    end

    respond_to do |format|
      set_trading_account_instruments_grid
      format.html { redirect_to @trading_account_instrument, notice: 'TradingAccountInstrument was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /trading_account_instruments/1
  # PATCH/PUT /trading_account_instruments/1.json
  def update
    TradingAccountInstrument.transaction do
      @trading_account_instrument.update!(trading_account_instrument_params)
    end

    respond_to do |format|
      set_trading_account_instruments_grid
      format.html { redirect_to @trading_account_instrument, notice: 'TradingAccountInstrument was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @trading_account_instrument = TradingAccountInstrument.find(params[:trading_account_instrument_id])
  end

  # DELETE /trading_account_instruments/1
  # DELETE /trading_account_instruments/1.json
  def destroy
    @trading_account_instrument.destroy!

    respond_to do |format|
      set_trading_account_instruments_grid
      format.html { redirect_to trading_account_instruments_url, notice: 'TradingAccountInstrument was successfully destroyed.' }
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
    def set_trading_account_instrument
      @trading_account_instrument = TradingAccountInstrument.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trading_account_instrument_params
      params.require(:trading_account_instrument).permit(
        :trading_account_id,
        :instrument_id,
        )
    end

    def set_trading_account_instruments_grid
      @trading_account_instruments_grid = initialize_grid(TradingAccountInstrument)
    end

    def set_trading_account
      @trading_account = TradingAccount.find(params[:trading_account_id])
    end
end

