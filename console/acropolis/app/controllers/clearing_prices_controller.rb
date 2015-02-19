class ClearingPricesController < ApplicationController
  before_action :set_clearing_price, only: [:show, :edit, :update, :destroy]

  # GET /clearing_prices
  # GET /clearing_prices.json
  def index
    @clearing_prices_grid = initialize_grid(ClearingPrice.all)
  end

  # GET /clearing_prices/1
  # GET /clearing_prices/1.json
  def show
  end

  # GET /clearing_prices/new
  def new
    @clearing_price = ClearingPrice.new
  end

  # GET /clearing_prices/1/edit
  def edit
  end

  # POST /clearing_prices
  # POST /clearing_prices.json
  def create
    ClearingPrice.transaction do
      @clearing_price = ClearingPrice.find_by_instrument_id_and_cleared_at(clearing_price_params[:instrument_id], clearing_price_params[:cleared_at].to_time)
      if @clearing_price.nil?
        @clearing_price = ClearingPrice.new(clearing_price_params)
        @clearing_price.save!
      else
        @clearing_price.update!(clearing_price_params)
      end
    end

    respond_to do |format|
      set_clearing_prices_grid
      format.html { redirect_to @clearing_price, notice: 'ClearingPrice was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /clearing_prices/1
  # PATCH/PUT /clearing_prices/1.json
  def update
    ClearingPrice.transaction do
      @clearing_price.update!(clearing_price_params)
    end

    respond_to do |format|
      set_clearing_prices_grid
      format.html { redirect_to @clearing_price, notice: 'ClearingPrice was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @clearing_price = ClearingPrice.find(params[:clearing_price_id])
  end

  # DELETE /clearing_prices/1
  # DELETE /clearing_prices/1.json
  def destroy
    @clearing_price.destroy!

    respond_to do |format|
      set_clearing_prices_grid
      format.html { redirect_to clearing_prices_url, notice: 'ClearingPrice was successfully destroyed.' }
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
    def set_clearing_price
      @clearing_price = ClearingPrice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clearing_price_params
      params.require(:clearing_price).permit(
        :instrument_id,
        :price,
        :exchange_instrument_code,
        :cleared_at,
        :exchange_code,
        )
    end

    def set_clearing_prices_grid
      @clearing_prices_grid = initialize_grid(ClearingPrice)
    end
end

