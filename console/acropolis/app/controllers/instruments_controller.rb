class InstrumentsController < ApplicationController
  before_action :set_instrument, only: [:show, :edit, :update, :destroy]

  # GET /instruments
  # GET /instruments.json
  def index
    @instruments_grid = initialize_grid(Instrument.all)
  end

  # GET /instruments/1
  # GET /instruments/1.json
  def show
  end

  # GET /instruments/new
  def new
    @instrument = Instrument.new
    @instrument.build_trading_fee
    @instrument.build_margin
    @exchange = Exchange.find(params[:exchange_id])
    @instrument.exchange = @exchange
  end

  # GET /instruments/1/edit
  def edit
    @instrument.build_trading_fee if @instrument.trading_fee.nil?
    @instrument.build_margin if @instrument.margin.nil?
  end

  # POST /instruments
  # POST /instruments.json
  def create
    Instrument.transaction do
      @instrument = Instrument.new(instrument_params)
      @exchange = @instrument.exchange
      @instrument.save!
    end

    respond_to do |format|
      set_instruments_grid
      format.html { redirect_to @instrument, notice: 'Instrument was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /instruments/1
  # PATCH/PUT /instruments/1.json
  def update
    Instrument.transaction do
      @instrument.update!(instrument_params)
      @exchange = @instrument.exchange
    end

    respond_to do |format|
      set_instruments_grid
      format.html { redirect_to @instrument, notice: 'Instrument was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @instrument = Instrument.find(params[:instrument_id])
  end

  # DELETE /instruments/1
  # DELETE /instruments/1.json
  def destroy
    @instrument.destroy!

    respond_to do |format|
      set_instruments_grid
      format.html { redirect_to instruments_url, notice: 'Instrument was successfully destroyed.' }
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
    def set_instrument
      @instrument = Instrument.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instrument_params
      params.require(:instrument).permit(
        :name,
        :symbol_id,
        :trading_symbol_id,
        :type,
        :expiration_date,
        :strike_price,
        :exchange_id,
        :exchange_name,
        :currency_id,
        :multiplier,
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

    def set_instruments_grid
      @instruments_grid = initialize_grid(Instrument.where(exchange_id: @exchange.id))
    end
end

