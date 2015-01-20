require 'rails_helper'

RSpec.describe "trading_summaries/edit", :type => :view do
  before(:each) do
    @trading_summary = assign(:trading_summary, TradingSummary.create!())
  end

  it "renders the edit trading_summary form" do
    render

    assert_select "form[action=?][method=?]", trading_summary_path(@trading_summary), "post" do
    end
  end
end
