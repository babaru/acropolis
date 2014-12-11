class TradingAccountsController < ApplicationController
  before_action :set_trading_account, only: [:show, :edit, :update, :destroy]
  before_action :set_product, only: [:new]

  # GET /trading_accounts
  # GET /trading_accounts.json
  def index
    if params[:product_id]
      @trading_accounts_grid = initialize_grid(TradingAccount.where(product_id: params[:product_id]))
    else
      @trading_accounts_grid = initialize_grid(TradingAccount.order(:product_id))
    end
  end

  # GET /trading_accounts/1
  # GET /trading_accounts/1.json
  def show
    cache_recent_item(:trading_account, @trading_account.id, @trading_account.name)

    @product = @trading_account.product
    @client = @product.client

    add_breadcrumb @product.client.name, client_path(@product.client)
    add_breadcrumb @product.name, product_path(@product)
    add_breadcrumb @trading_account.name, nil

    @trading_records_grid = initialize_grid(Trade.where(trading_account_id: @trading_account.id).order('traded_at DESC'))
    @trading_account_instruments_grid = initialize_grid(TradingAccountInstrument.where(trading_account_id: @trading_account.id))
    @trading_account_budget_records_grid = initialize_grid(TradingAccountBudgetRecord.where(trading_account_id: @trading_account.id).order(:created_at))

    @buy_positions = Trade.whose(@trading_account.id).select(
        :instrument_id,
        :trade_price,
        :order_side,
        :trading_account_id,
        Arel::Nodes::NamedFunction.new('sum', [Trade.arel_table[:open_volume]]).as('open_volume'),
        :open_close,
        :traded_at
      ).where(
        Trade.arel_table[:open_volume].gt(0).and(
          Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.open).and(
            Trade.arel_table[:order_side].eq(Acropolis::OrderSides.order_sides.buy)
          )
        )
      ).order(:traded_at).reverse_order.group(:instrument_id, :trade_price)

    @buy_position_summary = Trade.whose(@trading_account.id).select(
        :instrument_id,
        :trade_price,
        :order_side,
        :trading_account_id,
        Arel::Nodes::NamedFunction.new('sum', [Trade.arel_table[:open_volume]]).as('open_volume'),
        :open_close,
        :traded_at
      ).where(
        Trade.arel_table[:open_volume].gt(0).and(
          Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.open).and(
            Trade.arel_table[:order_side].eq(Acropolis::OrderSides.order_sides.buy)
          )
        )
      ).order(:traded_at).reverse_order.group(:instrument_id)

    @sell_positions = Trade.whose(@trading_account.id).select(
        :instrument_id,
        :trade_price,
        :order_side,
        :trading_account_id,
        Arel::Nodes::NamedFunction.new('sum', [Trade.arel_table[:open_volume]]).as('open_volume'),
        :open_close,
        :traded_at
      ).where(
        Trade.arel_table[:open_volume].gt(0).and(
          Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.open).and(
            Trade.arel_table[:order_side].eq(Acropolis::OrderSides.order_sides.sell)
          )
        )
      ).order(:traded_at).reverse_order.group(:instrument_id, :trade_price)

    @sell_position_summary = Trade.whose(@trading_account.id).select(
        :instrument_id,
        :trade_price,
        :order_side,
        :trading_account_id,
        Arel::Nodes::NamedFunction.new('sum', [Trade.arel_table[:open_volume]]).as('open_volume'),
        :open_close,
        :traded_at
      ).where(
        Trade.arel_table[:open_volume].gt(0).and(
          Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.open).and(
            Trade.arel_table[:order_side].eq(Acropolis::OrderSides.order_sides.sell)
          )
        )
      ).order(:traded_at).reverse_order.group(:instrument_id)

    @trading_account_risk_plans_grid = initialize_grid(TradingAccountRiskPlan.where(
      TradingAccountRiskPlan.arel_table[:trading_account_id].eq(@trading_account.id).and(
        TradingAccountRiskPlan.arel_table[:type].eq(TradingAccountRiskPlan.name))
      ))

    @holiday_trading_account_risk_plans_grid = initialize_grid(TradingAccountRiskPlan.where(
      TradingAccountRiskPlan.arel_table[:trading_account_id].eq(@trading_account.id).and(
        TradingAccountRiskPlan.arel_table[:type].eq(HolidayTradingAccountRiskPlan.name))
      ))
  end

  def clearing
    @trading_account = TradingAccount.find params[:trading_account_id]
  end

  # GET /trading_accounts/new
  def new
    @trading_account = TradingAccount.new
    @trading_account.product = @product
    @trading_account.budget = 0
  end

  # GET /trading_accounts/1/edit
  def edit
  end

  # POST /trading_accounts
  # POST /trading_accounts.json
  def create
    TradingAccount.transaction do
      @trading_account = TradingAccount.new(trading_account_params)
      @trading_account.budget ||= 0
      @trading_account.save!
      @product = @trading_account.product
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
      @product = @trading_account.product
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
    remove_recent_item(:trading_account, @trading_account.id)
    @product = @trading_account.product
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

  def calculate_trading_summary
    @trading_account = TradingAccount.find(params[:trading_account_id])
    @trading_account.calculate_trading_summary
  end

  def export

    RBase.create_table '/Users/apple/Projects/acropolis/console/acropolis/public/system/people' do |t|
      t.column :name, :string, :size => 30
      t.column :birthdate, :date
      t.column :active, :boolean
      t.column :tax, :integer, :size => 10, :decimal => 2
    end

    table = RBase::Table.open('/Users/apple/Projects/acropolis/console/acropolis/public/system/people')
    person = table.build({name: 'sldfsad', birthdate: Date.new(1980,7,16), active: true, tax: 12.2})
    person.save
    table.close

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
        :account_no,
        :password,
        :legal_id,
        :budget,
        :product_id,
        )
    end

    def set_trading_accounts_grid
      @trading_accounts_grid = initialize_grid(TradingAccount.where(product_id: @product.id))
    end
end

