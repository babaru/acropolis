class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :bind_risk_plan]
  before_action :set_client, only: [:new]

  # add_breadcrumb I18n.t('navigation.page.product'), :products_path, only: [:show]

  # GET /products
  # GET /products.json
  def index
    @products_grid = initialize_grid(Product.all)

    add_breadcrumb I18n.t('navigation.page.product'), nil
  end

  # GET /products/1
  # GET /products/1.json
  def show
    cache_recent_item(:product, @product.id, @product.name)
    add_breadcrumb @product.client.name, client_path(@product.client)
    add_breadcrumb @product.name, nil

    @client = @product.client

    @product_risk_plans_grid = initialize_grid(ProductRiskPlan.where(
      ProductRiskPlan.arel_table[:product_id].eq(@product.id).and(
        ProductRiskPlan.arel_table[:type].eq(ProductRiskPlan.name))
      ))

    @holiday_product_risk_plans_grid = initialize_grid(ProductRiskPlan.where(
      ProductRiskPlan.arel_table[:product_id].eq(@product.id).and(
        ProductRiskPlan.arel_table[:type].eq(HolidayProductRiskPlan.name))
      ))

    @trading_accounts_grid = initialize_grid(TradingAccount.where(product_id: @product.id))
  end

  # GET /products/new
  def new
    @product = Product.new
    @product.client = @client
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    Product.transaction do
      @product = Product.new(product_params)
      @client = @product.client
      @product.save!
    end

    respond_to do |format|
      set_products_grid
      format.html { redirect_to @product, notice: 'Product was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # POST /products/1/bind_risk_plan
  def bind_risk_plan
    Product.transaction do
      unless ProductRiskPlan.exists?(risk_plan_id: params[:risk_plan_id], product_id: @product.id)
        ProductRiskPlan.create!(risk_plan_id: params[:risk_plan_id], product_id: @product.id)
      end
    end

    respond_to do |format|
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    Product.transaction do
      @product.update!(product_params)
      @client = @product.client
    end

    respond_to do |format|
      set_products_grid
      format.html { redirect_to @product, notice: 'Product was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @product = Product.find(params[:product_id])
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @client = @product.client
    remove_recent_item(:product, @product.id)
    @product.trading_accounts.each { |trading_account| remove_recent_item(:trading_account, trading_account.id) }
    @product.destroy!

    respond_to do |format|
      set_products_grid
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :delete }
      format.js { render :delete }
    end
  end

  def monitor
    @product = Product.find(params[:product_id])
    @monitoring_product = MonitoringProduct.where(product_id: @product.id, user_id: current_user.id).first
    Product.transaction do
      if @monitoring_product.nil?
        MonitoringProduct.create!(product_id: @product.id, user_id: current_user.id)
      else
        @monitoring_product.destroy!
      end
    end

    respond_to do |format|
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.js { render :monitor }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(
        :name,
        :long_name,
        :client_id,
        :budget,
        :broker_id,
        :bank_id
        )
    end

    def set_products_grid
      @products_grid = initialize_grid(Product.where(client_id: @client.id))
    end

    def set_client
      @client = Client.find(params[:client_id])
    end
end

