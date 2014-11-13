class TradingAccountsController < ApplicationController
  before_action :set_trading_account, only: [:show, :edit, :update, :destroy]
  before_action :set_product, only: [:index, :new]

  # GET /trading_accounts
  # GET /trading_accounts.json
  def index
    @trading_accounts_grid = initialize_grid(TradingAccount.where(product_id: params[:product_id]))
  end

  # GET /trading_accounts/1
  # GET /trading_accounts/1.json
  def show
  end

  # GET /trading_accounts/new
  def new
    @trading_account = TradingAccount.new
    @trading_account.product = @product
  end

  # GET /trading_accounts/1/edit
  def edit
  end

  # POST /trading_accounts
  # POST /trading_accounts.json
  def create
    TradingAccount.transaction do
      @trading_account = TradingAccount.new(trading_account_params)
      @trading_account.save!
    end

    respond_to do |format|
      set_trading_accounts_grid
      format.html { redirect_to @trading_account, notice: 'TradingAccount was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /trading_accounts/1
  # PATCH/PUT /trading_accounts/1.json
  def update
    TradingAccount.transaction do
      @trading_account.update!(trading_account_params)
    end

    respond_to do |format|
      set_trading_accounts_grid
      format.html { redirect_to @trading_account, notice: 'TradingAccount was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @trading_account = TradingAccount.find(params[:trading_account_id])
  end

  # DELETE /trading_accounts/1
  # DELETE /trading_accounts/1.json
  def destroy
    @trading_account.destroy!

    respond_to do |format|
      set_trading_accounts_grid
      format.html { redirect_to trading_accounts_url, notice: 'TradingAccount was successfully destroyed.' }
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
    def set_trading_account
      @trading_account = TradingAccount.find(params[:id])
    end

    def set_product
      @product = Product.find params[:product_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trading_account_params
      params.require(:trading_account).permit(
        :name,
        :budget,
        :product_id,
        )
    end

    def set_trading_accounts_grid
      @trading_accounts_grid = initialize_grid(TradingAccount)
    end
end
