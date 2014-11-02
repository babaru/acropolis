class RiskPlansController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_risk_plan, only: [:show, :edit, :update, :destroy]
  before_action :set_parameter, only: [:index, :new, :create, :edit, :update, :destroy]

  add_breadcrumb 'Acropolis', :root_path

  # GET /risk_plans
  # GET /risk_plans.json
  def index
    set_risk_plans_grid
  end

  # GET /risk_plans/1
  # GET /risk_plans/1.json
  def show
    @risk_plan_operations_grid = initialize_grid(RiskPlanOperation.where(risk_plan_id: @risk_plan.id))
  end

  # GET /risk_plans/new
  def new
    # @current_product = Product.find params[:product_id]
    @risk_plan = RiskPlan.new
    # @risk_plan.product = @current_product
  end

  # GET /risk_plans/1/edit
  def edit
    # @current_product = @risk_plan.product
  end

  # POST /risk_plans
  # POST /risk_plans.json
  def create
    RiskPlan.transaction do
      @risk_plan = RiskPlan.new(risk_plan_params)
      @risk_plan.created_by = current_user
      update_thresholds(:net_worth)
      update_thresholds(:parameter)
      @risk_plan.save!
    end

    respond_to do |format|
      set_risk_plans_grid
      format.html { redirect_to @risk_plan, notice: 'Risk plan was successfully created.'}
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
      update_thresholds(:net_worth)
      update_thresholds(:parameter)
      @risk_plan.update!(risk_plan_params)
    end

    respond_to do |format|
      set_risk_plans_grid
      format.html { redirect_to @risk_plan, notice: 'Risk plan was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  # GET /risk_plans/1
  def delete
    @risk_plan = RiskPlan.find(params[:risk_plan_id])
  end

  def enable
    @risk_plan = RiskPlan.find(params[:risk_plan_id])
    @current_product = @risk_plan.product
    set_risk_plans_grid

    @risk_plan.is_enabled = !@risk_plan.is_enabled
    @risk_plan.save
  end

  # DELETE /risk_plans/1
  # DELETE /risk_plans/1.json
  def destroy
    set_risk_plans_grid
    @risk_plan.destroy

    respond_to do |format|
      format.html { redirect_to risk_plans_url, notice: 'Risk plan was successfully destroyed.' }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_risk_plan
      @risk_plan = RiskPlan.find(params[:id])
    end

    def set_parameter
      @parameter = params[:p]
      unless @parameter.nil?
        @parameter.downcase!
        unless %w(in_bound_net_worth out_bound_net_worth net_worth margin exposure).include?(@parameter)
          @parameter = 'unknown'
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def risk_plan_params
      params.require(:risk_plan).permit(
        :name,
        :is_enabled,
        :created_by_id,
        :net_worth_threshold_ids => [],
        :net_worth_threshold_relation_symbols => [],
        :net_worth_threshold_values => [],
        :net_worth_threshold_removal_flags => [],
        :net_worth_threshold_parameters => []
      )
    end

    def set_risk_plans_grid
      unless @parameter.nil?
        @risk_plans_grid = initialize_grid(RiskPlan.joins(:parameter).where("product_id=? AND parameters.name LIKE ?", @current_product.id, "%#{@parameter}%"))
      else
        @risk_plans_grid = initialize_grid(RiskPlan)
      end
    end

    def update_thresholds(threshold_type)
      return unless %w(net_worth parameter).include?(threshold_type.to_s)

      type_string = "#{threshold_type.to_s.camelize}Threshold"
      ids_symbol = "#{threshold_type}_threshold_ids".to_sym
      removal_flags_symbol = "#{threshold_type}_threshold_removal_flags".to_sym
      relation_symbols_symbol = "#{threshold_type}_threshold_relation_symbols".to_sym
      values_symbol = "#{threshold_type}_threshold_values".to_sym
      parameters_symbol = "#{threshold_type}_threshold_parameters".to_sym

      @risk_plan.thresholds.where(type: type_string).clear
      threshold_ids = risk_plan_params[ids_symbol]
      unless threshold_ids.nil?
        threshold_ids.each_with_index do |item, index|
          threshold = nil
          unless item.nil? || item.blank?
            threshold = Threshold.find(item)
            if risk_plan_params[removal_flags_symbol][index] == 'true'
              threshold.destroy
              threshold = nil
            else
              threshold.relation_symbol_id = risk_plan_params[relation_symbols_symbol][index]
              threshold.value = risk_plan_params[values_symbol][index]
              threshold.parameter_id = risk_plan_params[parameters_symbol][index]
            end
          else
            unless risk_plan_params[removal_flags_symbol][index] == 'true'
              threshold = Threshold.new(
                {
                  type: type_string,
                  relation_symbol_id: risk_plan_params[relation_symbols_symbol][index],
                  value: risk_plan_params[values_symbol][index],
                  parameter_id: risk_plan_params[parameters_symbol][index]
                }
              )
            end
          end
          @risk_plan.thresholds << threshold unless threshold.nil?
        end
      end
    end
end
