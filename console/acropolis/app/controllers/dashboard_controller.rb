class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @risk_events_grid = initialize_grid(RiskEvent.all.order('happened_at DESC'), per_page: 5)
  end

  def switch_monitor_layout
    @style = params[:style]
    @style ||= 'panel'
    @style = @style.to_sym
    if @style != :panel
      @products_monitoring_grid = initialize_grid(Product.all, per_page: 1)
    end
  end

end
