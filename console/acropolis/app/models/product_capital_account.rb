class ProductCapitalAccount < ActiveRecord::Base
  belongs_to :product
  belongs_to :capital_account
end
