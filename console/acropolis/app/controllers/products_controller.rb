class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('navigation.page.product'), :products_path, only: [:show]

  # GET /products
  # GET /products.json
  def index
    @products_grid = initialize_grid(Product.all)

    add_breadcrumb I18n.t('navigation.page.product'), nil
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product_risk_plans_grid = initialize_grid(ProductRiskPlan.where(product_id: @product.id))
    cache_recent_item(:product, @product.id, @product.name)

    add_breadcrumb @product.name, nil
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    Product.transaction do
      @product = Product.new(product_params)
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

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    Product.transaction do
      @product.update!(product_params)
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
        :bank_id,
        )
    end

    def set_products_grid
      @products_grid = initialize_grid(Product)
    end
end

