require 'rails_helper'

RSpec.describe "clearing_prices/index", :type => :view do
  before(:each) do
    assign(:clearing_prices, [
      ClearingPrice.create!(),
      ClearingPrice.create!()
    ])
  end

  it "renders a list of clearing_prices" do
    render
  end
end
