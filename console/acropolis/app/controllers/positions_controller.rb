class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]

  # GET /positions
  # GET /positions.json
  def index
    @positions_grid = initialize_grid(Position.all)
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
  end

  # GET /positions/new
  def new
    @position = Position.new
  end

  # GET /positions/1/edit
  def edit
  end

  # POST /positions
  # POST /positions.json
  def create
    Position.transaction do
      @position = Position.new(position_params)
      @position.save!
    end

    respond_to do |format|
      set_positions_grid
      format.html { redirect_to @position, notice: 'Position was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /positions/1
  # PATCH/PUT /positions/1.json
  def update
    Position.transaction do
      @position.update!(position_params)
    end

    respond_to do |format|
      set_positions_grid
      format.html { redirect_to @position, notice: 'Position was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @position = Position.find(params[:position_id])
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position.destroy!

    respond_to do |format|
      set_positions_grid
      format.html { redirect_to positions_url, notice: 'Position was successfully destroyed.' }
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
    def set_position
      @position = Position.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      params.require(:position).permit(
        :order_side,
        :volume,
        :trade_price,
        :instrument_id,
        :trading_account_id,
        )
    end

    def set_positions_grid
      @positions_grid = initialize_grid(Position)
    end
end

