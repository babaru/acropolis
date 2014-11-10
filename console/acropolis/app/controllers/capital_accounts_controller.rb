class CapitalAccountsController < ApplicationController
  before_action :set_capital_account, only: [:show, :edit, :update, :destroy]
  before_action :set_client, only: [:index, :new]

  # GET /capital_accounts
  # GET /capital_accounts.json
  def index
    @capital_accounts_grid = initialize_grid(CapitalAccount.all)
  end

  # GET /capital_accounts/1
  # GET /capital_accounts/1.json
  def show
  end

  # GET /capital_accounts/new
  def new
    @capital_account = CapitalAccount.new
    @capital_account.client = @client
  end

  # GET /capital_accounts/1/edit
  def edit
  end

  # POST /capital_accounts
  # POST /capital_accounts.json
  def create
    CapitalAccount.transaction do
      @capital_account = CapitalAccount.new(capital_account_params)
      @capital_account.save!
    end

    respond_to do |format|
      set_capital_accounts_grid
      format.html { redirect_to @capital_account, notice: 'CapitalAccount was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /capital_accounts/1
  # PATCH/PUT /capital_accounts/1.json
  def update
    CapitalAccount.transaction do
      @capital_account.update!(capital_account_params)
    end

    respond_to do |format|
      set_capital_accounts_grid
      format.html { redirect_to @capital_account, notice: 'CapitalAccount was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @capital_account = CapitalAccount.find(params[:capital_account_id])
  end

  # DELETE /capital_accounts/1
  # DELETE /capital_accounts/1.json
  def destroy
    @capital_account.destroy!

    respond_to do |format|
      set_capital_accounts_grid
      format.html { redirect_to capital_accounts_url, notice: 'CapitalAccount was successfully destroyed.' }
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
    def set_capital_account
      @capital_account = CapitalAccount.find(params[:id])
    end

    def set_client
      @client = Client.find(params[:client_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def capital_account_params
      params.require(:capital_account).permit(
        :name,
        :budget,
        :client_id,
        )
    end

    def set_capital_accounts_grid
      @capital_accounts_grid = initialize_grid(CapitalAccount)
    end
end

