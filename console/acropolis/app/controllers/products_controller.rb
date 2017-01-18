class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  QUERY_KEYS = [:name].freeze
  ARRAY_SP = ","
  ARRAY_HEADER = "a_"

  TABS = [:tab1, :tab2].freeze

  # GET /products
  # GET /products.json
  def index
    @query_params = {}

    if request.post?
      build_query_params(params[:product])
      redirect_to products_path(@query_params)
    else
      build_query_params(params)
    end

    build_query_product_params

    @conditions = []
    @conditions << Product.arel_table[:name].matches("%#{@query_params[:name]}%") if @query_params[:name]

    if @conditions.length > 0
      conditions = @conditions[0]
      @conditions.each_with_index do |item, index|
        conditions = conditions.or(item) if index > 0
      end
      @conditions = conditions
    end

    # @products_grid = initialize_grid(Product)
    @products_grid = ProductsGrid.new(params[:grid]) do |scope|
      scope.page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html {  }
      format.json { render json: Product.where(@conditions) }
    end
  end

  def build_query_params(parameters)
    QUERY_KEYS.each do |key|
      if parameters[key].is_a?(Array)
        @query_params[key] = "a_#{parameters[key].join(ARRAY_SP)}"
      else
        @query_params[key] = parameters[key] if parameters[key] && !parameters[key].empty?
      end
    end
  end

  def build_query_product_params
    @query_product_params = Product.new
    QUERY_KEYS.each do |key|
      if @query_params[key] && @query_params[key].start_with?(ARRAY_HEADER)
        @query_product_params.send("#{key}=", @query_params[key].gsub(ARRAY_HEADER, "").split(ARRAY_SP))
      else
        @query_product_params.send("#{key}=", @query_params[key])
      end
    end
  end

  def search
    redirect_to :index
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @tabs = TABS
    @current_tab = params[:tab]
    @current_tab ||= TABS.first.to_s
    @current_tab = @current_tab.to_sym
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
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        set_products_grid
        format.html { redirect_to @product, notice: t('activerecord.success.messages.created', model: Product.model_name.human) }
        format.js
      else
        format.html { render :new }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        set_products_grid
        format.html { redirect_to @product, notice: t('activerecord.success.messages.updated', model: Product.model_name.human) }
        format.js
      else
        format.html { render :edit }
        format.js { render :edit }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      set_products_grid
      format.html { redirect_to products_url, notice: t('activerecord.success.messages.destroyed', model: Product.model_name.human) }
      format.js
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
      :client_id,
      :budget,
      :broker_id,
      :bank_id,
      )
  end

  def set_products_grid(conditions = [])
    @products_grid = initialize_grid(Product.where(conditions))
  end
end
