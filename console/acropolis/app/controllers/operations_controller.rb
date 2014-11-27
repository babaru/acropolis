class OperationsController < ApplicationController
  before_action :set_operation, only: [:show, :edit, :update, :destroy]

  # GET /operations
  # GET /operations.json
  def index
    @operations_grid = initialize_grid(Operation.all)
  end

  # GET /operations/1
  # GET /operations/1.json
  def show
  end

  # GET /operations/new
  def new
    @operation = Operation.new
  end

  # GET /operations/1/edit
  def edit
  end

  # POST /operations
  # POST /operations.json
  def create
    Operation.transaction do
      @operation = Operation.new(operation_params)
      @operation.save!
    end

    respond_to do |format|
      set_operations_grid
      format.html { redirect_to @operation, notice: 'Operation was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /operations/1
  # PATCH/PUT /operations/1.json
  def update
    Operation.transaction do
      @operation.update!(operation_params)
    end

    respond_to do |format|
      set_operations_grid
      format.html { redirect_to @operation, notice: 'Operation was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @operation = Operation.find(params[:operation_id])
  end

  # DELETE /operations/1
  # DELETE /operations/1.json
  def destroy
    @operation.destroy!

    respond_to do |format|
      set_operations_grid
      format.html { redirect_to operations_url, notice: 'Operation was successfully destroyed.' }
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
    def set_operation
      @operation = Operation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def operation_params
      params.require(:operation).permit(
        :name,
        :level,
        )
    end

    def set_operations_grid
      @operations_grid = initialize_grid(Operation)
    end
end

