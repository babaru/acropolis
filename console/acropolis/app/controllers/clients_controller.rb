class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  # GET /clients
  # GET /clients.json
  def index
    @clients_grid = initialize_grid(Client.all)
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @capital_accounts_grid = initialize_grid(CapitalAccount.where(client_id: @client.id))
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
end

