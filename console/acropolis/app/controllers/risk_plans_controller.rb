class RiskPlansController < ApplicationController
  before_action :set_risk_plan, only: [:show, :edit, :update, :destroy]

  # GET /risk_plans
  # GET /risk_plans.json
  def index
    @risk_plans = RiskPlan.all
  end

  # GET /risk_plans/1
  # GET /risk_plans/1.json
  def show
  end

  # GET /risk_plans/new
  def new
    @risk_plan = RiskPlan.new
  end

  # GET /risk_plans/1/edit
  def edit
  end

  # POST /risk_plans
  # POST /risk_plans.json
  def create
    @risk_plan = RiskPlan.new(risk_plan_params.permit[:risk_plan_attribute])
    @risk_plan

    respond_to do |format|
      if @risk_plan.save
        format.html { redirect_to @risk_plan, notice: 'Risk plan was successfully created.' }
        format.json { render :show, status: :created, location: @risk_plan }
      else
        format.html { render :new }
        format.json { render json: @risk_plan.errors, status: :unprocessable_entity }
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
      params[:risk_plan]
    end
end
