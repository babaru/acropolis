class ProductRiskPlansController < ApplicationController
  before_action :set_product_risk_plan, only: [:show, :edit, :update, :destroy]
  before_action :set_product, only: [:index, :new]

  # GET /product_risk_plans
  # GET /product_risk_plans.json
  def index
    @product_risk_plans_grid = initialize_grid(ProductRiskPlan.all)
  end

  # GET /product_risk_plans/1
  # GET /product_risk_plans/1.json
  def show
  end

  # GET /product_risk_plans/new
  def new
    @product_risk_plan = ProductRiskPlan.new
    @product_risk_plan.product = @product
  end

  # GET /product_risk_plans/1/edit
  def edit
  end

  # POST /product_risk_plans
  # POST /product_risk_plans.json
  def create
    ProductRiskPlan.transaction do
      @product_risk_plan = ProductRiskPlan.new(product_risk_plan_params)
      @product_risk_plan.save!
    end

    respond_to do |format|
      set_product_risk_plans_grid
      format.html { redirect_to @product_risk_plan, notice: 'ProductRiskPlan was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /product_risk_plans/1
  # PATCH/PUT /product_risk_plans/1.json
  def update
    ProductRiskPlan.transaction do
      @product_risk_plan.update!(product_risk_plan_params)
    end

    respond_to do |format|
      set_product_risk_plans_grid
      format.html { redirect_to @product_risk_plan, notice: 'ProductRiskPlan was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @product_risk_plan = ProductRiskPlan.find(params[:product_risk_plan_id])
  end

  # DELETE /product_risk_plans/1
  # DELETE /product_risk_plans/1.json
  def destroy
    @product_risk_plan.destroy!

    respond_to do |format|
      set_product_risk_plans_grid
      format.html { redirect_to product_risk_plans_url, notice: 'ProductRiskPlan was successfully destroyed.' }
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :delete }
      format.js { render :delete }
    end
  end

  # POST /product_risk_plans/1/enable
  def enable
    @product_risk_plan = ProductRiskPlan.find params[:product_risk_plan_id]
    @product_risk_plan.is_enabled = !@product_risk_plan.is_enabled
    @product_risk_plan.save!
    @product = @product_risk_plan.product

    respond_to do |format|
      # set_product_risk_plans_grid
      format.html { redirect_to @product_risk_plan, notice: 'Product risk plan was successfully updated.'}
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
    def set_product_risk_plan
      @product_risk_plan = ProductRiskPlan.find(params[:id])
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_risk_plan_params
      params.require(:product_risk_plan).permit(
        :product_id,
        :risk_plan_id,
        :is_enabled,
        )
    end

    def set_product_risk_plans_grid
      @product_risk_plans_grid = initialize_grid(ProductRiskPlan)
    end
end

