class RiskPlanOperationsController < ApplicationController
  before_action :set_risk_plan_operation, only: [:show, :edit, :update, :destroy]
  before_action :set_risk_plan, only: [:index, :new, :edit, :update, :destroy]

  # GET /risk_plan_operations
  # GET /risk_plan_operations.json
  def index
    set_risk_plan_operations_grid
  end

  # GET /risk_plan_operations/1
  # GET /risk_plan_operations/1.json
  def show
  end

  # GET /risk_plan_operations/new
  def new
    @risk_plan_operation = RiskPlanOperation.new
    @risk_plan_operation.risk_plan = @risk_plan
  end

  # GET /risk_plan_operations/1/edit
  def edit
  end

  # POST /risk_plan_operations
  # POST /risk_plan_operations.json
  def create
    @risk_plan_operation = RiskPlanOperation.new(risk_plan_operation_params)
    @risk_plan = RiskPlan.find @risk_plan_operation.risk_plan_id
    set_risk_plan_operations_grid

    respond_to do |format|
      if @risk_plan_operation.save
        format.html { redirect_to @risk_plan_operation, notice: 'Risk plan operation was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /risk_plan_operations/1
  # PATCH/PUT /risk_plan_operations/1.json
  def update
    set_risk_plan_operations_grid
    respond_to do |format|
      if @risk_plan_operation.update(risk_plan_operation_params)
        format.html { redirect_to @risk_plan_operation, notice: 'Risk plan operation was successfully updated.' }
        format.json { render :show, status: :ok, location: @risk_plan_operation }
      else
        format.html { render :edit }
        format.json { render json: @risk_plan_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /risk_plan_operations/1
  # DELETE /risk_plan_operations/1.json
  def destroy
    @risk_plan_operation.destroy
    respond_to do |format|
      format.html { redirect_to risk_plan_operations_url, notice: 'Risk plan operation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_risk_plan_operation
    @risk_plan_operation = RiskPlanOperation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def risk_plan_operation_params
    params.require(:risk_plan_operation).permit(
      :risk_plan_id,
      :operation_id,
      :is_enabled,
      :threshold_ids => [],
      :threshold_relation_symbols => [],
      :threshold_values => [],
      :threshold_removal_flags => [],
      :threshold_parameters => []
    )
  end

  def set_risk_plan
    @risk_plan = RiskPlan.find(params[:risk_plan_id])
  end

  def set_risk_plan_operations_grid
    @risk_plan_operations_grid = initialize_grid(RiskPlanOperation.where(risk_plan_id: @risk_plan.id))
  end

  def update_thresholds
    @risk_plan_operation.thresholds.clear
    threshold_ids = risk_plan_operation_params[:threshold_ids]
    unless threshold_ids.nil?
      threshold_ids.each_with_index do |item, index|
        threshold = nil
        unless item.nil? || item.blank?
          threshold = Threshold.find(item)
          if risk_plan_opeartion_params[:threshold_removal_flags][index] == 'true'
            threshold.destroy
            threshold = nil
          else
            threshold.relation_symbol_id = risk_plan_opeartion_params[:threshold_relation_symbols][index]
            threshold.value = risk_plan_opeartion_params[:threshold_values][index]
            threshold.parameter_id = risk_plan_opeartion_params[:threshold_parameters][index]
          end
        else
          unless risk_plan_opeartion_params[:threshold_removal_flags][index] == 'true'
            threshold = Threshold.new(
              {
                type: type_string,
                relation_symbol_id: risk_plan_opeartion_params[:threshold_relation_symbols][index],
                value: risk_plan_opeartion_params[:threshold_values][index],
                parameter_id: risk_plan_opeartion_params[:threshold_parameters][index]
              }
            )
          end
        end
        @risk_plan_operation.thresholds << threshold unless threshold.nil?
      end
    end
  end
end
