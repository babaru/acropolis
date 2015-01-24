class TradingSymbolsController < ApplicationController
  before_action :set_trading_symbol, only: [:show, :edit, :update, :destroy]

  # GET /trading_symbols
  # GET /trading_symbols.json
  def index
    @trading_symbols_grid = initialize_grid(TradingSymbol.all)
  end

  # GET /trading_symbols/1
  # GET /trading_symbols/1.json
  def show
  end

  # GET /trading_symbols/new
  def new
    @trading_symbol = TradingSymbol.new
    @trading_symbol.build_trading_symbol_margin
    @trading_symbol.build_margin
  end

  # GET /trading_symbols/1/edit
  def edit
    @trading_symbol.build_trading_fee if @trading_symbol.trading_fee.nil?
    @trading_symbol.build_margin if @trading_symbol.margin.nil?
  end

  # POST /trading_symbols
  # POST /trading_symbols.json
  def create
    TradingSymbol.transaction do
      @trading_symbol = TradingSymbol.new(trading_symbol_params)
      @trading_symbol.save!
    end

    respond_to do |format|
      set_trading_symbols_grid
      format.html { redirect_to @trading_symbol, notice: 'TradingSymbol was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /trading_symbols/1
  # PATCH/PUT /trading_symbols/1.json
  def update
    TradingSymbol.transaction do
      @trading_symbol.update!(trading_symbol_params)
    end

    respond_to do |format|
      set_trading_symbols_grid
      format.html { redirect_to @trading_symbol, notice: 'TradingSymbol was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @trading_symbol = TradingSymbol.find(params[:trading_symbol_id])
  end

  # DELETE /trading_symbols/1
  # DELETE /trading_symbols/1.json
  def destroy
    @trading_symbol.destroy!

    respond_to do |format|
      set_trading_symbols_grid
      format.html { redirect_to trading_symbols_url, notice: 'TradingSymbol was successfully destroyed.' }
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
    def set_trading_symbol
      @trading_symbol = TradingSymbol.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trading_symbol_params
      params.require(:trading_symbol).permit(
        :name,
        :exchange_id,
        :currency_id,
        :multiplier,
        :trading_symbol_type,
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

    def set_trading_symbols_grid
      @trading_symbols_grid = initialize_grid(TradingSymbol)
    end
end

