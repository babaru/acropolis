<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"
<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  QUERY_KEYS = [:name].freeze
  ARRAY_SP = ","
  ARRAY_HEADER = "a_"

  TABS = [:tab1, :tab2].freeze

  # GET <%= route_url %>
  # GET <%= route_url %>.json
  def index
    @query_params = {}

    if request.post?
      build_query_params(params[:<%= singular_table_name %>])
      redirect_to <%= plural_table_name %>_path(@query_params)
    else
      build_query_params(params)
    end

    build_query_<%= singular_table_name %>_params

    @conditions = []
    @conditions << <%= class_name.split('::').last %>.arel_table[:name].matches("%#{@query_params[:name]}%") if @query_params[:name]

    if @conditions.length > 0
      conditions = @conditions[0]
      @conditions.each_with_index do |item, index|
        conditions = conditions.or(item) if index > 0
      end
      @conditions = conditions
    end

    respond_to do |format|
      format.html { set_<%= plural_table_name %>_grid(@conditions) }
      format.json { render json: <%= class_name.split('::').last %>.where(@conditions) }
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

  def build_query_<%= singular_table_name %>_params
    @query_<%= singular_table_name %>_params = <%= class_name.split('::').last %>.new
    QUERY_KEYS.each do |key|
      if @query_params[key] && @query_params[key].start_with?(ARRAY_HEADER)
        @query_<%= singular_table_name %>_params.send("#{key}=", @query_params[key].gsub(ARRAY_HEADER, "").split(ARRAY_SP))
      else
        @query_<%= singular_table_name %>_params.send("#{key}=", @query_params[key])
      end
    end
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.json
  def show
    @tabs = TABS
    @current_tab = params[:tab]
    @current_tab ||= TABS.first.to_s
    @current_tab = @current_tab.to_sym
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= class_name.split('::').last %>.new
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.json
  def create
    @<%= singular_table_name %> = <%= class_name.split('::').last %>.new(<%= singular_table_name %>_params)

    respond_to do |format|
      if @<%= singular_table_name %>.save
        set_<%= plural_table_name %>_grid
        format.html { redirect_to @<%= singular_table_name %>, notice: t('activerecord.success.messages.created', model: <%= class_name.split('::').last %>.model_name.human) }
        format.js
      else
        format.html { render :new }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT <%= route_url %>/1
  # PATCH/PUT <%= route_url %>/1.json
  def update
    respond_to do |format|
      if @<%= singular_table_name %>.update(<%= singular_table_name %>_params)
        set_<%= plural_table_name %>_grid
        format.html { redirect_to @<%= singular_table_name %>, notice: t('activerecord.success.messages.updated', model: <%= class_name.split('::').last %>.model_name.human) }
        format.js
      else
        format.html { render :edit }
        format.js { render :edit }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.json
  def destroy
    @<%= singular_table_name %>.destroy

    respond_to do |format|
      set_<%= plural_table_name %>_grid
      format.html { redirect_to <%= index_helper %>_url, notice: t('activerecord.success.messages.destroyed', model: <%= class_name.split('::').last %>.model_name.human) }
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_<%= singular_table_name %>
    @<%= singular_table_name %> = <%= class_name.split('::').last %>.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def <%= singular_table_name %>_params
    params.require(:<%= singular_table_name %>).permit(
      <% class_name.split('::').last.constantize.columns.each_with_index do |item, index| %><% if item.name != "id" && item.name !="created_at" && item.name !="updated_at" %>:<%= item.name%>,
      <% end %><% end %>)
  end

  def set_<%= plural_table_name %>_grid(conditions = [])
    @<%= plural_table_name %>_grid = initialize_grid(<%= class_name.split('::').last %>.where(conditions))
  end
end

<% end -%>
