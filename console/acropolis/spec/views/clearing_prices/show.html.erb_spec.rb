require 'rails_helper'

RSpec.describe "clearing_prices/show", :type => :view do
  before(:each) do
    @clearing_price = assign(:clearing_price, ClearingPrice.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
