require 'rails_helper'

RSpec.describe "clearing_prices/edit", :type => :view do
  before(:each) do
    @clearing_price = assign(:clearing_price, ClearingPrice.create!())
  end

  it "renders the edit clearing_price form" do
    render

    assert_select "form[action=?][method=?]", clearing_price_path(@clearing_price), "post" do
    end
  end
end
