require "rails_helper"

RSpec.describe TradingSummariesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/trading_summaries").to route_to("trading_summaries#index")
    end

    it "routes to #new" do
      expect(:get => "/trading_summaries/new").to route_to("trading_summaries#new")
    end

    it "routes to #show" do
      expect(:get => "/trading_summaries/1").to route_to("trading_summaries#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/trading_summaries/1/edit").to route_to("trading_summaries#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/trading_summaries").to route_to("trading_summaries#create")
    end

    it "routes to #update" do
      expect(:put => "/trading_summaries/1").to route_to("trading_summaries#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/trading_summaries/1").to route_to("trading_summaries#destroy", :id => "1")
    end

  end
end
