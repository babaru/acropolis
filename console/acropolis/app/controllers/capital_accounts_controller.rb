

class CapitalAccountsController < ApplicationController
  before_action :set_capital_account, only: [:show, :edit, :update, :destroy]

  QUERY_KEYS = [:name].freeze
  ARRAY_SP = ","
  ARRAY_HEADER = "a_"

  TABS = [:gateways].freeze

  # GET /capital_accounts
  # GET /capital_accounts.json
  def index
    @query_params = {}
    build_query_params(params)
    build_query_capital_account_params

    @conditions = []
    @conditions << CapitalAccount.arel_table[:name].matches("%#{@query_params[:name]}%") if @query_params[:name]

    if @conditions.length > 0
      conditions = @conditions[0]
      @conditions.each_with_index do |item, index|
        conditions = conditions.or(item) if index > 0
      end
      @conditions = conditions
    end

    respond_to do |format|
      format.html { set_capital_accounts_grid(@conditions) }
      format.json { render json: CapitalAccount.where(@conditions) }
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

  def build_query_capital_account_params
    @query_capital_account_params = CapitalAccount.new
    QUERY_KEYS.each do |key|
      if @query_params[key] && @query_params[key].start_with?(ARRAY_HEADER)
        @query_capital_account_params.send("#{key}=", @query_params[key].gsub(ARRAY_HEADER, "").split(ARRAY_SP))
      else
        @query_capital_account_params.send("#{key}=", @query_params[key])
      end
    end
  end

  def search
    if request.post?
      build_query_params(params[:capital_account])
      redirect_to capital_accounts_path(@query_params)
    end
  end

  # GET /capital_accounts/1
  # GET /capital_accounts/1.json
  def show
    @tabs = TABS
    @current_tab = params[:tab]
    @current_tab ||= TABS.first.to_s
    @current_tab = @current_tab.to_sym
  end

  # GET /capital_accounts/new
  def new
    @capital_account = CapitalAccount.new
    @capital_account.product_id = params[:product_id]
  end

  # GET /capital_accounts/1/edit
  def edit
  end

  # POST /capital_accounts
  # POST /capital_accounts.json
  def create
    @capital_account = CapitalAccount.new(capital_account_params)

    respond_to do |format|
      if @capital_account.save
        set_capital_accounts_grid
        format.html { redirect_to @capital_account, notice: t('activerecord.success.messages.created', model: CapitalAccount.model_name.human) }
        format.js
      else
        format.html { render :new }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /capital_accounts/1
  # PATCH/PUT /capital_accounts/1.json
  def update
    respond_to do |format|
      if @capital_account.update(capital_account_params)
        set_capital_accounts_grid
        format.html { redirect_to @capital_account, notice: t('activerecord.success.messages.updated', model: CapitalAccount.model_name.human) }
        format.js
      else
        format.html { render :edit }
        format.js { render :edit }
      end
    end
  end

  # DELETE /capital_accounts/1
  # DELETE /capital_accounts/1.json
  def destroy
    @capital_account.destroy

    respond_to do |format|
      set_capital_accounts_grid
      format.html { redirect_to capital_accounts_url, notice: t('activerecord.success.messages.destroyed', model: CapitalAccount.model_name.human) }
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_capital_account
    @capital_account = CapitalAccount.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def capital_account_params
    params.require(:capital_account).permit(
      :name,
      :product_id,
      )
  end

  def set_capital_accounts_grid(conditions = [])
    @capital_accounts_grid = CapitalAccountGrid.new do |scope|
      scope.page(params[:page]).where(conditions).per(20)
    end
  end
end
