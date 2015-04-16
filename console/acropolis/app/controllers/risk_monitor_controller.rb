class RiskMonitorController < ApplicationController
  before_filter :authenticate_user!

  def index
    @current_time = Time.now
  end
end
