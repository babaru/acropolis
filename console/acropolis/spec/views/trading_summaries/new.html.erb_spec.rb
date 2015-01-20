require 'rails_helper'

RSpec.describe "trading_summaries/new", :type => :view do
  before(:each) do
    assign(:trading_summary, TradingSummary.new())
  end

  it "renders new trading_summary form" do
    render

    assert_select "form[action=?][method=?]", trading_summaries_path, "post" do
    end
  end
end
