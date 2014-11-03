class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index

    @products_monitoring_grid = initialize_grid(Product.all)
    @recent_risk_plans_grid = initialize_grid(RiskPlan.where("id in (#{recent_items(:risk_plan).map {|id, name| [id]}.join(',')})"))

  end
end
