require 'rails_helper'

RSpec.describe "trading_summaries/index", :type => :view do
  before(:each) do
    assign(:trading_summaries, [
      TradingSummary.create!(),
      TradingSummary.create!()
    ])
  end

  it "renders a list of trading_summaries" do
    render
  end
end
