require "rails_helper"

RSpec.describe ClearingPricesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/clearing_prices").to route_to("clearing_prices#index")
    end

    it "routes to #new" do
      expect(:get => "/clearing_prices/new").to route_to("clearing_prices#new")
    end

    it "routes to #show" do
      expect(:get => "/clearing_prices/1").to route_to("clearing_prices#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/clearing_prices/1/edit").to route_to("clearing_prices#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/clearing_prices").to route_to("clearing_prices#create")
    end

    it "routes to #update" do
      expect(:put => "/clearing_prices/1").to route_to("clearing_prices#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/clearing_prices/1").to route_to("clearing_prices#destroy", :id => "1")
    end

  end
end
