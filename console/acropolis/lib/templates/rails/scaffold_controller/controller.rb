<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= class_name.split('::').last.underscore.downcase %>, only: [:show, :edit, :update, :destroy]

  # GET <%= route_url %>
  # GET <%= route_url %>.json
  def index
    @<%= class_name.split('::').last.underscore.downcase.pluralize %>_grid = initialize_grid(<%= class_name.split('::').last %>.all)
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.json
  def show
  end

  # GET <%= route_url %>/new
  def new
    @<%= class_name.split('::').last.underscore.downcase %> = <%= class_name.split('::').last %>.new
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.json
  def create
    <%= class_name.split('::').last %>.transaction do
      @<%= class_name.split('::').last.underscore.downcase %> = <%= class_name.split('::').last %>.new(<%= class_name.split('::').last.underscore.downcase %>_params)
      @<%= class_name.split('::').last.underscore.downcase %>.save!
    end

    respond_to do |format|
      set_<%= class_name.split('::').last.underscore.downcase.pluralize %>_grid
      format.html { redirect_to @<%= class_name.split('::').last.underscore.downcase %>, notice: '<%= class_name.split('::').last %> was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT <%= route_url %>/1
  # PATCH/PUT <%= route_url %>/1.json
  def update
    <%= class_name.split('::').last %>.transaction do
      @<%= class_name.split('::').last.underscore.downcase %>.update!(<%= class_name.split('::').last.underscore.downcase %>_params)
    end

    respond_to do |format|
      set_<%= class_name.split('::').last.underscore.downcase.pluralize %>_grid
      format.html { redirect_to @<%= class_name.split('::').last.underscore.downcase %>, notice: '<%= class_name.split('::').last %> was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @<%= class_name.split('::').last.underscore.downcase %> = <%= class_name.split('::').last %>.find(params[:<%= class_name.split('::').last.underscore.downcase %>_id])
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.json
  def destroy
    @<%= class_name.split('::').last.underscore.downcase %>.destroy!

    respond_to do |format|
      set_<%= class_name.split('::').last.underscore.downcase.pluralize %>_grid
      format.html { redirect_to <%= class_name.split('::').last.underscore.downcase.pluralize %>_url, notice: '<%= class_name.split('::').last %> was successfully destroyed.' }
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
    def set_<%= class_name.split('::').last.underscore.downcase %>
      @<%= class_name.split('::').last.underscore.downcase %> = <%= class_name.split('::').last %>.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def <%= class_name.split('::').last.underscore.downcase %>_params
      params.require(:<%= class_name.split('::').last.underscore.downcase %>).permit(
        <% class_name.split('::').last.constantize.columns.each_with_index do |item, index| %><% if item.name != "id" && item.name !="created_at" && item.name !="updated_at" %>:<%= item.name%>,
        <% end %><% end %>)
    end

    def set_<%= class_name.split('::').last.underscore.downcase.pluralize %>_grid
      @<%= class_name.split('::').last.underscore.downcase.pluralize %>_grid = initialize_grid(<%= class_name.split('::').last %>)
    end
end

<% end -%>
