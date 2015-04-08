class TradingAccountBudgetRecordsController < ApplicationController
  before_action :set_trading_account_budget_record, only: [:show, :edit, :update, :destroy]
  before_action :set_trading_account, only: [:index, :new]

  # GET /trading_account_budget_records
  # GET /trading_account_budget_records.json
  def index
    set_trading_account_budget_records_grid
  end

  # GET /trading_account_budget_records/1
  # GET /trading_account_budget_records/1.json
  def show
  end

  # GET /trading_account_budget_records/new
  def new
    @trading_account_budget_record = TradingAccountBudgetRecord.new
    @trading_account_budget_record.trading_account = @trading_account
  end

  # GET /trading_account_budget_records/1/edit
  def edit
  end

  # POST /trading_account_budget_records
  # POST /trading_account_budget_records.json
  def create
    TradingAccountBudgetRecord.transaction do
      @trading_account_budget_record = TradingAccountBudgetRecord.new(trading_account_budget_record_params)
      @trading_account_budget_record.save!

      @trading_account = @trading_account_budget_record.trading_account
    end

    respond_to do |format|
      set_trading_account_budget_records_grid
      format.html { redirect_to @trading_account_budget_record, notice: 'TradingAccountBudgetRecord was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /trading_account_budget_records/1
  # PATCH/PUT /trading_account_budget_records/1.json
  def update
    TradingAccountBudgetRecord.transaction do
      @trading_account_budget_record.update!(trading_account_budget_record_params)
      @trading_account = @trading_account_budget_record.trading_account
    end

    respond_to do |format|
      set_trading_account_budget_records_grid
      format.html { redirect_to @trading_account_budget_record, notice: 'TradingAccountBudgetRecord was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @trading_account_budget_record = TradingAccountBudgetRecord.find(params[:trading_account_budget_record_id])
  end

  # DELETE /trading_account_budget_records/1
  # DELETE /trading_account_budget_records/1.json
  def destroy
    @trading_account = @trading_account_budget_record.trading_account
    @trading_account_budget_record.destroy!

    respond_to do |format|
      set_trading_account_budget_records_grid
      format.html { redirect_to trading_account_budget_records_url, notice: 'TradingAccountBudgetRecord was successfully destroyed.' }
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
    def set_trading_account_budget_record
      @trading_account_budget_record = TradingAccountBudgetRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trading_account_budget_record_params
      params.require(:trading_account_budget_record).permit(
        :trading_account_id,
        :budget_type,
        :money,
        )
    end

    def set_trading_account
      @trading_account = TradingAccount.find(params[:trading_account_id])
    end

    def set_trading_account_budget_records_grid
      @trading_account_budget_records_grid = initialize_grid(TradingAccountBudgetRecord.where(trading_account_id: @trading_account.id))
    end
end

