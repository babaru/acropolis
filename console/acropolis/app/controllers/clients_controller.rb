class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :set_query_params, only: [:show]

  add_breadcrumb I18n.t('navigation.page.client'), 'javascript:void(0);'
  add_breadcrumb I18n.t('models.list', model: Client.model_name.human), :clients_path, only: [:show]

  # GET /clients
  # GET /clients.json
  def index
    @clients_grid = initialize_grid(Client.all)
    add_breadcrumb I18n.t('models.list', model: Client.model_name.human), nil
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    cache_recent_item(:client, @client.id, @client.name)
    add_breadcrumb t('models.show', model: Client.model_name.human), nil

    @trading_accounts_grid = initialize_grid(TradingAccount.where(client_id: @client.id))
    @products_grid = initialize_grid(Product.where(client_id: @client.id))

  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    Client.transaction do
      @client = Client.new(client_params)
      @client.save!
    end

    respond_to do |format|
      set_clients_grid
      format.html { redirect_to @client, notice: 'Client was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    Client.transaction do
      @client.update!(client_params)
    end

    respond_to do |format|
      set_clients_grid
      format.html { redirect_to @client, notice: 'Client was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @client = Client.find(params[:client_id])
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    remove_recent_item(:client, @client.id)
    @client.products.each do |product|
      remove_recent_item(:product, product.id)
      project.trading_accounts.each do |trading_account|
        remove_recent_item(:trading_account, trading_account.id)
      end
    end

    @client.destroy!

    respond_to do |format|
      set_clients_grid
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
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
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(
        :name,
        )
    end

    def set_clients_grid
      @clients_grid = initialize_grid(Client)
    end

    def set_query_params
      @query_params = {}

      @query_params[:tab] = params[:tab] if params[:tab]
      @current_tab = @query_params[:tab]
      @current_tab ||= 'trading_accounts'
      @current_tab = @current_tab.to_sym
    end
end

