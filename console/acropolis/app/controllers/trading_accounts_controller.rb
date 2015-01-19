class TradingAccountsController < ApplicationController
  before_action :set_trading_account, only: [:show, :edit, :update, :destroy]
  # before_action :set_product, only: [:new]
  before_action :set_client, only: [:new]

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

    @client = @trading_account.client

    add_breadcrumb @client.name, client_path(@client)
    add_breadcrumb @trading_account.name, nil

    @trading_records_grid = initialize_grid(Trade.where(trading_account_id: @trading_account.id).order('exchange_traded_at DESC'))
    @trading_account_instruments_grid = initialize_grid(TradingAccountInstrument.where(trading_account_id: @trading_account.id))
    @trading_account_budget_records_grid = initialize_grid(TradingAccountBudgetRecord.where(trading_account_id: @trading_account.id).order(:created_at))

    @buy_positions = Trade.whose(@trading_account.id).select(
        :instrument_id,
        :traded_price,
        :order_side,
        :trading_account_id,
        Arel::Nodes::NamedFunction.new('sum', [Trade.arel_table[:open_volume]]).as('open_volume'),
        :open_close,
        :exchange_traded_at
      ).where(
        Trade.arel_table[:open_volume].gt(0).and(
          Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.open).and(
            Trade.arel_table[:order_side].eq(Acropolis::OrderSides.order_sides.buy)
          )
        )
      ).order(:exchange_traded_at).reverse_order.group(:instrument_id, :traded_price)

    @buy_position_summary = Trade.whose(@trading_account.id).select(
        :instrument_id,
        :traded_price,
        :order_side,
        :trading_account_id,
        Arel::Nodes::NamedFunction.new('sum', [Trade.arel_table[:open_volume]]).as('open_volume'),
        :open_close,
        :exchange_traded_at
      ).where(
        Trade.arel_table[:open_volume].gt(0).and(
          Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.open).and(
            Trade.arel_table[:order_side].eq(Acropolis::OrderSides.order_sides.buy)
          )
        )
      ).order(:exchange_traded_at).reverse_order.group(:instrument_id)

    @sell_positions = Trade.whose(@trading_account.id).select(
        :instrument_id,
        :traded_price,
        :order_side,
        :trading_account_id,
        Arel::Nodes::NamedFunction.new('sum', [Trade.arel_table[:open_volume]]).as('open_volume'),
        :open_close,
        :exchange_traded_at
      ).where(
        Trade.arel_table[:open_volume].gt(0).and(
          Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.open).and(
            Trade.arel_table[:order_side].eq(Acropolis::OrderSides.order_sides.sell)
          )
        )
      ).order(:exchange_traded_at).reverse_order.group(:instrument_id, :traded_price)

    @sell_position_summary = Trade.whose(@trading_account.id).select(
        :instrument_id,
        :traded_price,
        :order_side,
        :trading_account_id,
        Arel::Nodes::NamedFunction.new('sum', [Trade.arel_table[:open_volume]]).as('open_volume'),
        :open_close,
        :exchange_traded_at
      ).where(
        Trade.arel_table[:open_volume].gt(0).and(
          Trade.arel_table[:open_close].eq(Acropolis::TradeOpenFlags.trade_open_flags.open).and(
            Trade.arel_table[:order_side].eq(Acropolis::OrderSides.order_sides.sell)
          )
        )
      ).order(:exchange_traded_at).reverse_order.group(:instrument_id)

    @trading_account_risk_plans_grid = initialize_grid(TradingAccountRiskPlan.where(
      TradingAccountRiskPlan.arel_table[:trading_account_id].eq(@trading_account.id).and(
        TradingAccountRiskPlan.arel_table[:type].eq(TradingAccountRiskPlan.name))
      ))

    @holiday_trading_account_risk_plans_grid = initialize_grid(TradingAccountRiskPlan.where(
      TradingAccountRiskPlan.arel_table[:trading_account_id].eq(@trading_account.id).and(
        TradingAccountRiskPlan.arel_table[:type].eq(HolidayTradingAccountRiskPlan.name))
      ))

    @clearing_capital = TradingAccountClearingCapital.recent(@trading_account.id)
  end

  def clearing
    @trading_account = TradingAccount.find params[:trading_account_id]
  end

  # GET /trading_accounts/new
  def new
    @trading_account = TradingAccount.new
    @trading_account.client = @client
    @trading_account.capital = 0
  end

  # GET /trading_accounts/1/edit
  def edit
  end

  # POST /trading_accounts
  # POST /trading_accounts.json
  def create
    TradingAccount.transaction do
      @trading_account = TradingAccount.new(trading_account_params)
      @trading_account.capital ||= 0
      @trading_account.save!
      @client = @trading_account.client
    end

    respond_to do |format|
      set_trading_accounts_grid
      format.html { redirect_to @trading_account, notice: 'TradingAccount was successfully created.'}
      format.js
    end
  rescue
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
      @client = @trading_account.client
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
    @client = @trading_account.client
    @trading_account.destroy!

    respond_to do |format|
      set_trading_accounts_grid
      format.html { redirect_to client_trading_accounts_path(@client), notice: 'TradingAccount was successfully destroyed.' }
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

  def uploading_clearing_capital_file
    @trading_account = TradingAccount.find(params[:trading_account_id])
    @upload_file = TradingAccountClearingCapitalFile.new
    @upload_file.trading_account_id = @trading_account.id
  end

  def upload_clearing_capital_file
    if request.post?
      @upload_file = TradingAccountClearingCapitalFile.new(trading_account_clearing_capital_file_params)
      if @upload_file.save
        @record = TradingAccountClearingCapital.find_by_trading_account_id_and_cleared_at(@upload_file.trading_account_id, @upload_file.cleared_at)
        unless @record.nil?
          @record.update(@upload_file.parse)
        else
          TradingAccountClearingCapital.create(@upload_file.parse)
        end
      end
    end
  end

  def uploading_clearing_trades_file
    @trading_account = TradingAccount.find(params[:trading_account_id])
    @upload_file = TradingAccountClearingTradesFile.new
    @upload_file.trading_account_id = @trading_account.id
  end

  def upload_clearing_trades_file
    if request.post?
      @trading_account = TradingAccount.find(trading_account_clearing_trades_file_params[:trading_account_id])
      @upload_file = TradingAccountClearingTradesFile.new(trading_account_clearing_trades_file_params)
      if @upload_file.save
        results = @upload_file.parse
        results[:trades].each do |trade_data|
          @trade = Trade.find_by_exchange_trade_id_and_exchange_instrument_code(trade_data[:exchange_trade_id], trade_data[:exchange_instrument_code])
          unless @trade.nil?
            @trade.update(trade_data)
          else
            puts "Exchange instrument code: #{trade_data[:exchange_instrument_code]}"
            instrument = Instrument.find_by_exchange_instrument_code(trade_data[:exchange_instrument_code])
            Trade.create(trade_data.merge({
              instrument_id: instrument.id,
              trading_account_id: @trading_account.id,
              trading_account_number: @trading_account.account_number,
              exchange_id: instrument.exchange_id,
              exchange_code: instrument.exchange.trading_code}))
          end
        end
      end
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

    def set_client
      @client = Client.find params[:client_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trading_account_params
      params.require(:trading_account).permit(
        :name,
        :account_number,
        :password,
        :legal_id,
        :capital,
        :client_id,
        )
    end

    def trading_account_clearing_capital_file_params
      params.require(:trading_account_clearing_capital_file).permit(
        :data_file,
        :cleared_at,
        :trading_account_id,
        )
    end

    def trading_account_clearing_trades_file_params
      params.require(:trading_account_clearing_trades_file).permit(
        :data_file,
        :cleared_at,
        :trading_account_id,
        )
    end

    def set_trading_accounts_grid
      @trading_accounts_grid = initialize_grid(TradingAccount.where(client_id: @client.id))
    end
end

