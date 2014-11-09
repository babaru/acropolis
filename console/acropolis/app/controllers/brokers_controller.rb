class BrokersController < ApplicationController
  before_action :set_broker, only: [:show, :edit, :update, :destroy]

  # GET /brokers
  # GET /brokers.json
  def index
    @brokers_grid = initialize_grid(Broker.all)
  end

  # GET /brokers/1
  # GET /brokers/1.json
  def show
  end

  # GET /brokers/new
  def new
    @broker = Broker.new
  end

  # GET /brokers/1/edit
  def edit
  end

  # POST /brokers
  # POST /brokers.json
  def create
    Broker.transaction do
      @broker = Broker.new(broker_params)
      @broker.save!
    end

    respond_to do |format|
      set_brokers_grid
      format.html { redirect_to @broker, notice: 'Broker was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /brokers/1
  # PATCH/PUT /brokers/1.json
  def update
    Broker.transaction do
      @broker.update!(broker_params)
    end

    respond_to do |format|
      set_brokers_grid
      format.html { redirect_to @broker, notice: 'Broker was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @broker = Broker.find(params[:broker_id])
  end

  # DELETE /brokers/1
  # DELETE /brokers/1.json
  def destroy
    @broker.destroy!

    respond_to do |format|
      set_brokers_grid
      format.html { redirect_to brokers_url, notice: 'Broker was successfully destroyed.' }
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
    def set_broker
      @broker = Broker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def broker_params
      params.require(:broker).permit(
        :name,
        )
    end

    def set_brokers_grid
      @brokers_grid = initialize_grid(Broker)
    end
end

