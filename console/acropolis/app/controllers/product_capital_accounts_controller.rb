class ProductCapitalAccountsController < ApplicationController
  before_action :set_product_capital_account, only: [:show, :edit, :update, :destroy]
  before_action :set_product, only: [:index, :new]

  # GET /product_capital_accounts
  # GET /product_capital_accounts.json
  def index
    @product_capital_accounts_grid = initialize_grid(ProductCapitalAccount.all)
  end

  # GET /product_capital_accounts/1
  # GET /product_capital_accounts/1.json
  def show
  end

  # GET /product_capital_accounts/new
  def new
    @product_capital_account = ProductCapitalAccount.new
    @product_capital_account.product = @product
  end

  # GET /product_capital_accounts/1/edit
  def edit
  end

  # POST /product_capital_accounts
  # POST /product_capital_accounts.json
  def create
    ProductCapitalAccount.transaction do
      @product_capital_account = ProductCapitalAccount.new(product_capital_account_params)
      @product = @product_capital_account.product
      @product_capital_account.save!
    end

    respond_to do |format|
      set_product_capital_accounts_grid
      format.html { redirect_to @product_capital_account, notice: 'ProductCapitalAccount was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /product_capital_accounts/1
  # PATCH/PUT /product_capital_accounts/1.json
  def update
    ProductCapitalAccount.transaction do
      @product_capital_account.update!(product_capital_account_params)
      @product = @product_capital_account.product
    end

    respond_to do |format|
      set_product_capital_accounts_grid
      format.html { redirect_to @product_capital_account, notice: 'ProductCapitalAccount was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @product_capital_account = ProductCapitalAccount.find(params[:product_capital_account_id])
  end

  # DELETE /product_capital_accounts/1
  # DELETE /product_capital_accounts/1.json
  def destroy
    @product = @product_capital_account.product
    @product_capital_account.destroy!

    respond_to do |format|
      set_product_capital_accounts_grid
      format.html { redirect_to product_capital_accounts_url, notice: 'ProductCapitalAccount was successfully destroyed.' }
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
    def set_product_capital_account
      @product_capital_account = ProductCapitalAccount.find(params[:id])
    end

    def set_product
      @product = Product.find params[:product_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_capital_account_params
      params.require(:product_capital_account).permit(
        :product_id,
        :capital_account_id,
        )
    end

    def set_product_capital_accounts_grid
      @product_capital_accounts_grid = initialize_grid(ProductCapitalAccount.where(product_id: @product.id))
    end
end

