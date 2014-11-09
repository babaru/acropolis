class BanksController < ApplicationController
  before_action :set_bank, only: [:show, :edit, :update, :destroy]

  # GET /banks
  # GET /banks.json
  def index
    @banks_grid = initialize_grid(Bank.all)
  end

  # GET /banks/1
  # GET /banks/1.json
  def show
  end

  # GET /banks/new
  def new
    @bank = Bank.new
  end

  # GET /banks/1/edit
  def edit
  end

  # POST /banks
  # POST /banks.json
  def create
    Bank.transaction do
      @bank = Bank.new(bank_params)
      @bank.save!
    end

    respond_to do |format|
      set_banks_grid
      format.html { redirect_to @bank, notice: 'Bank was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /banks/1
  # PATCH/PUT /banks/1.json
  def update
    Bank.transaction do
      @bank.update!(bank_params)
    end

    respond_to do |format|
      set_banks_grid
      format.html { redirect_to @bank, notice: 'Bank was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @bank = Bank.find(params[:bank_id])
  end

  # DELETE /banks/1
  # DELETE /banks/1.json
  def destroy
    @bank.destroy!

    respond_to do |format|
      set_banks_grid
      format.html { redirect_to banks_url, notice: 'Bank was successfully destroyed.' }
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
    def set_bank
      @bank = Bank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_params
      params.require(:bank).permit(
        :name,
        )
    end

    def set_banks_grid
      @banks_grid = initialize_grid(Bank)
    end
end

