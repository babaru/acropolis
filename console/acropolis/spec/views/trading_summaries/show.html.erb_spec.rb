require 'rails_helper'

RSpec.describe "trading_summaries/show", :type => :view do
  before(:each) do
    @trading_summary = assign(:trading_summary, TradingSummary.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
