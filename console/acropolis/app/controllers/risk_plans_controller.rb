class RiskPlansController < ApplicationController
  before_action :set_risk_plan, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('navigation.page.risk_plan'), :risk_plans_path, only: [:show]

  # GET /risk_plans
  # GET /risk_plans.json
  def index
    add_breadcrumb I18n.t('navigation.page.risk_plan'), nil

    @risk_plans_grid = initialize_grid(RiskPlan.all)
  end

  # GET /risk_plans/1
  # GET /risk_plans/1.json
  def show

    add_breadcrumb @risk_plan.name, nil

    @risk_plan_operations_grid = initialize_grid(RiskPlanOperation.where(risk_plan_id: @risk_plan.id))
    cache_recent_item(:risk_plan, @risk_plan.id, @risk_plan.name)
    @binding_products_grid = initialize_grid(ProductRiskPlan.where(risk_plan_id: @risk_plan.id))
  end

  # GET /risk_plans/new
  def new
    @risk_plan = RiskPlan.new
    @risk_plan.created_by = User.second
  end

  # GET /risk_plans/1/edit
  def edit
  end

  # POST /risk_plans
  # POST /risk_plans.json
  def create
    RiskPlan.transaction do
      @risk_plan = RiskPlan.new(risk_plan_params)
      @risk_plan.save!
    end

    respond_to do |format|
      set_risk_plans_grid
      format.html { redirect_to @risk_plan, notice: 'RiskPlan was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /risk_plans/1
  # PATCH/PUT /risk_plans/1.json
  def update
    RiskPlan.transaction do
      @risk_plan.update!(risk_plan_params)
    end

    respond_to do |format|
      set_risk_plans_grid
      format.html { redirect_to @risk_plan, notice: 'RiskPlan was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @risk_plan = RiskPlan.find(params[:risk_plan_id])
  end

  # DELETE /risk_plans/1
  # DELETE /risk_plans/1.json
  def destroy
    @risk_plan.destroy!

    respond_to do |format|
      set_risk_plans_grid
      format.html { redirect_to risk_plans_url, notice: 'RiskPlan was successfully destroyed.' }
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
    def set_risk_plan
      @risk_plan = RiskPlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def risk_plan_params
      params.require(:risk_plan).permit(
        :name,
        :created_by_id,
        )
    end

    def set_risk_plans_grid
      @risk_plans_grid = initialize_grid(RiskPlan)
    end
end

