class TradingSummariesController < ApplicationController
  before_action :set_trading_summary, only: [:show, :edit, :update, :destroy]

  # GET /trading_summaries
  # GET /trading_summaries.json
  def index
    @trading_summaries_grid = initialize_grid(TradingSummary.all)
  end

  # GET /trading_summaries/1
  # GET /trading_summaries/1.json
  def show
  end

  # GET /trading_summaries/new
  def new
    @trading_date = params[:trading_date].to_time if params[:trading_date]
    @trading_date ||= Time.zone.now
    @exchange = Exchange.find params[:exchange_id] if params[:exchange_id]
    @trading_summary = TradingSummary.new
    @trading_summary.trading_date = @trading_date
    @trading_summary.exchange = @exchange if @exchange
    @trading_summary.trading_account_id = params[:trading_account_id]
  end

  # GET /trading_summaries/1/edit
  def edit
  end

  # POST /trading_summaries
  # POST /trading_summaries.json
  def create
    trading_date = trading_summary_params[:trading_date].to_time
    @trading_summary = TradingSummary.find_by_trading_account_id_and_exchange_id_and_trading_date(
        trading_summary_params[:trading_account_id],
        trading_summary_params[:exchange_id],
        trading_date)
    TradingSummary.transaction do
      if @trading_summary.nil?
        @trading_summary = TradingSummary.new({
          trading_account_id: trading_summary_params[:trading_account_id],
          exchange_id: trading_summary_params[:exchange_id],
          trading_date: trading_date})
        @trading_summary.save!
      end

      @trading_summary.update!(trading_summary_params)
    end

    respond_to do |format|
      set_trading_summaries_grid
      format.html { redirect_to @trading_summary, notice: 'TradingSummary was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /trading_summaries/1
  # PATCH/PUT /trading_summaries/1.json
  def update
    TradingSummary.transaction do
      @trading_summary.update!(trading_summary_params)
    end

    respond_to do |format|
      set_trading_summaries_grid
      format.html { redirect_to @trading_summary, notice: 'TradingSummary was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @trading_summary = TradingSummary.find(params[:trading_summary_id])
  end

  # DELETE /trading_summaries/1
  # DELETE /trading_summaries/1.json
  def destroy
    @trading_summary.destroy!

    respond_to do |format|
      set_trading_summaries_grid
      format.html { redirect_to trading_summaries_url, notice: 'TradingSummary was successfully destroyed.' }
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
    def set_trading_summary
      @trading_summary = TradingSummary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trading_summary_params
      params.require(:trading_summary).permit(
        :type,
        :trading_date,
        :exchange_id,
        :latest_trade_id,
        :trading_account_id,
        :balance,
        :capital,
        )
    end

    def set_trading_summaries_grid
      @trading_summaries_grid = initialize_grid(TradingSummary)
    end
end

