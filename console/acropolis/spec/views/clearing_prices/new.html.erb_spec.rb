require 'rails_helper'

RSpec.describe "clearing_prices/new", :type => :view do
  before(:each) do
    assign(:clearing_price, ClearingPrice.new())
  end

  it "renders new clearing_price form" do
    render

    assert_select "form[action=?][method=?]", clearing_prices_path, "post" do
    end
  end
end
