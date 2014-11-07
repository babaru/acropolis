class MonitoringProductsController < ApplicationController
  before_action :set_monitoring_product, only: [:show, :edit, :update, :destroy]

  # GET /monitoring_products
  # GET /monitoring_products.json
  def index
    @monitoring_products_grid = initialize_grid(MonitoringProduct.all)
  end

  def list
    @products_grid = initialize_grid(Product.all)
  end

  # GET /monitoring_products/1
  # GET /monitoring_products/1.json
  def show
  end

  # GET /monitoring_products/new
  def new
    @monitoring_product = MonitoringProduct.new
    @monitoring_product.user = current_user
    @user = current_user
  end

  # GET /monitoring_products/1/edit
  def edit
  end

  # POST /monitoring_products
  # POST /monitoring_products.json
  def create
    MonitoringProduct.transaction do
      @monitoring_product = MonitoringProduct.new(monitoring_product_params)
      @monitoring_product.save!
    end

    respond_to do |format|
      set_monitoring_products_grid
      format.html { redirect_to @monitoring_product, notice: 'MonitoringProduct was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /monitoring_products/1
  # PATCH/PUT /monitoring_products/1.json
  def update
    MonitoringProduct.transaction do
      @monitoring_product.update!(monitoring_product_params)
    end

    respond_to do |format|
      set_monitoring_products_grid
      format.html { redirect_to @monitoring_product, notice: 'MonitoringProduct was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @monitoring_product = MonitoringProduct.find(params[:monitoring_product_id])
  end

  # DELETE /monitoring_products/1
  # DELETE /monitoring_products/1.json
  def destroy
    @monitoring_product.destroy!

    respond_to do |format|
      set_monitoring_products_grid
      format.html { redirect_to monitoring_products_url, notice: 'MonitoringProduct was successfully destroyed.' }
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
    def set_monitoring_product
      @monitoring_product = MonitoringProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monitoring_product_params
      params.require(:monitoring_product).permit(
        :product_id,
        :user_id,
        )
    end

    def set_monitoring_products_grid
      @monitoring_products_grid = initialize_grid(MonitoringProduct)
    end
end

