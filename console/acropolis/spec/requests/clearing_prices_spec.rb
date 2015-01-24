require 'rails_helper'

RSpec.describe "ClearingPrices", :type => :request do
  describe "GET /clearing_prices" do
    it "works! (now write some real specs)" do
      get clearing_prices_path
      expect(response).to have_http_status(200)
    end
  end
end
