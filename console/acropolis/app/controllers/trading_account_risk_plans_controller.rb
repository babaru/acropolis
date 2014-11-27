class TradingAccountRiskPlansController < ApplicationController
  before_action :set_trading_account_risk_plan, only: [:show, :edit, :update, :destroy]
  before_action :set_trading_account, only: [:index, :new]

  # GET /trading_account_risk_plans
  # GET /trading_account_risk_plans.json
  def index
    set_trading_account_risk_plans_grid
  end

  # GET /trading_account_risk_plans/1
  # GET /trading_account_risk_plans/1.json
  def show
  end

  # GET /trading_account_risk_plans/new
  def new
    @trading_account_risk_plan = TradingAccountRiskPlan.new
    @trading_account_risk_plan.trading_account = @trading_account
    @trading_account_risk_plan.type = params[:type]
  end

  # GET /trading_account_risk_plans/1/edit
  def edit
  end

  # POST /trading_account_risk_plans
  # POST /trading_account_risk_plans.json
  def create
    TradingAccountRiskPlan.transaction do
      @trading_account_risk_plan = TradingAccountRiskPlan.new(trading_account_risk_plan_params)
      @trading_account = @trading_account_risk_plan.trading_account
      set_duration_columns
      @trading_account_risk_plan.save!
    end

    respond_to do |format|
      set_trading_account_risk_plans_grid
      format.html { redirect_to @trading_account_risk_plan, notice: 'TradingAccountRiskPlan was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /trading_account_risk_plans/1
  # PATCH/PUT /trading_account_risk_plans/1.json
  def update
    @trading_account = @trading_account_risk_plan.trading_account

    TradingAccountRiskPlan.transaction do
      set_duration_columns
      @trading_account_risk_plan.update!(trading_account_risk_plan_params)
    end

    respond_to do |format|
      set_trading_account_risk_plans_grid
      format.html { redirect_to @trading_account_risk_plan, notice: 'TradingAccountRiskPlan was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @trading_account_risk_plan = TradingAccountRiskPlan.find(params[:trading_account_risk_plan_id])
  end

  # DELETE /trading_account_risk_plans/1
  # DELETE /trading_account_risk_plans/1.json
  def destroy
    @trading_account = @trading_account_risk_plan.trading_account
    @trading_account_risk_plan.destroy!

    respond_to do |format|
      set_trading_account_risk_plans_grid
      format.html { redirect_to trading_account_risk_plans_url, notice: 'TradingAccountRiskPlan was successfully destroyed.' }
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :delete }
      format.js { render :delete }
    end
  end

  # POST /trading_account_risk_plans/1/enable
  def enable
    @trading_account_risk_plan = TradingAccountRiskPlan.find params[:trading_account_risk_plan_id]
    @trading_account_risk_plan.is_enabled = !@trading_account_risk_plan.is_enabled
    @trading_account_risk_plan.save!
    @trading_account = @trading_account_risk_plan.trading_account

    respond_to do |format|
      # set_trading_account_risk_plans_grid
      format.html { redirect_to @trading_account_risk_plan, notice: 'Trading account risk plan was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :enable }
      format.js { render :enable }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trading_account_risk_plan
      @trading_account_risk_plan = TradingAccountRiskPlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trading_account_risk_plan_params
      params.require(:trading_account_risk_plan).permit(
        :trading_account_id,
        :risk_plan_id,
        :is_enabled,
        :begun_at,
        :ended_at,
        :type,
        )
    end

    def set_trading_account
      @trading_account = TradingAccount.find(params[:trading_account_id])
    end

    def set_trading_account_risk_plans_grid
      @trading_account_risk_plans_grid = initialize_grid(TradingAccountRiskPlan.where(
      TradingAccountRiskPlan.arel_table[:trading_account_id].eq(@trading_account.id).and(
        TradingAccountRiskPlan.arel_table[:type].eq(TradingAccountRiskPlan.name))
      ))

      @holiday_trading_account_risk_plans_grid = initialize_grid(TradingAccountRiskPlan.where(
        TradingAccountRiskPlan.arel_table[:trading_account_id].eq(@trading_account.id).and(
          TradingAccountRiskPlan.arel_table[:type].eq(HolidayTradingAccountRiskPlan.name))
        ))
    end

    def set_duration_columns
      @trading_account_risk_plan.begun_at = Time.new(1900, 1, 1) if @trading_account_risk_plan.begun_at.nil?
      @trading_account_risk_plan.ended_at = Time.new(2050, 12, 31) if @trading_account_risk_plan.ended_at.nil?
    end
end

