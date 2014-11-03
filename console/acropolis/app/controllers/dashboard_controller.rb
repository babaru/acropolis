class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index

    @products_monitoring_grid = initialize_grid(Product.all)
    @recent_risk_plans_grid = initialize_grid(RiskPlan.where("id in (#{recent_items(:risk_plan).map {|id, name| [id]}.join(',')})"))

    if recent_items(:product).length > 0
      @recent_products_grid = initialize_grid(Product.where("id in (#{recent_items(:product).map {|id, name| [id]}.join(',')})"))
    else
      @recent_products_grid = initialize_grid(Product.where(id: 0))
    end

  end
end
