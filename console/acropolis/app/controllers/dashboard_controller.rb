class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index

    @products_monitoring_grid = initialize_grid(Product.all)

    @risk_events_grid = initialize_grid(RiskEvent.all.order('happened_at DESC'), per_page: 5)

  end
end
