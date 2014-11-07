class MonitoringController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.js
    end
  end
end
