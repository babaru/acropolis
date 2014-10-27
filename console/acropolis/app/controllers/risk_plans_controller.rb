class RiskPlansController < ApplicationController
  before_action :set_risk_plan, only: [:show, :edit, :update, :destroy]

  # GET /risk_plans
  # GET /risk_plans.json
  def index
    @current_product = Product.find params[:product_id]
    @current_product = Product.first if @current_product.nil?
    set_risk_plans_grid(@current_product.id)
  end

  # GET /risk_plans/1
  # GET /risk_plans/1.json
  def show
  end

  # GET /risk_plans/new
  def new
    @current_product = Product.find params[:product_id]
    @risk_plan = RiskPlan.new
    @risk_plan.product = @current_product
  end

  # GET /risk_plans/1/edit
  def edit
  end

  # POST /risk_plans
  # POST /risk_plans.json
  def create
    @risk_plan = RiskPlan.new(risk_plan_params)
    @current_product = @risk_plan.product
    set_risk_plans_grid(@current_product.id)

    threshold_ids = risk_plan_params[:threshold_ids]
    unless threshold_ids.nil?
      threshold_ids.each_with_index do |item, index|
        unless item.nil? || item.blank?
          @risk_plan.thresholds.find(item).relation_symbol_id = risk_plan_params[:threshold_relation_symbols][index]
          @risk_plan.thresholds.find(item).value = risk_plan_params[:threshold_values][index]
        else
          @risk_plan.thresholds << Threshold.new(
            {
              relation_symbol_id: risk_plan_params[:threshold_relation_symbols][index],
              value: risk_plan_params[:threshold_values][index]
            }
          )

          logger.debug("relation_symbol_id: #{@risk_plan.thresholds[index].relation_symbol_id}")
        end
      end
    end

    respond_to do |format|
      if @risk_plan.save
        format.html { redirect_to @risk_plan, notice: 'Risk plan was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /risk_plans/1
  # PATCH/PUT /risk_plans/1.json
  def update
    respond_to do |format|
      if @risk_plan.update(risk_plan_params)
        format.html { redirect_to @risk_plan, notice: 'Risk plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @risk_plan }
      else
        format.html { render :edit }
        format.json { render json: @risk_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /risk_plans/1
  # DELETE /risk_plans/1.json
  def destroy
    @risk_plan.destroy
    respond_to do |format|
      format.html { redirect_to risk_plans_url, notice: 'Risk plan was successfully destroyed.' }
      format.json { head :no_content }
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
        :parameter_id,
        :operation_id,
        :is_enabled,
        :product_id,
        :threshold_ids => [],
        :threshold_relation_symbols => [],
        :threshold_values => []
      )
    end

    def set_risk_plans_grid(product_id)
      @risk_plans_grid = initialize_grid(RiskPlan.where(product_id: product_id))
    end
end
