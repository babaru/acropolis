require 'rails_helper'

RSpec.describe "TradingSummaries", :type => :request do
  describe "GET /trading_summaries" do
    it "works! (now write some real specs)" do
      get trading_summaries_path
      expect(response).to have_http_status(200)
    end
  end
end
