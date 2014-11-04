class ProductRiskParameter < ActiveRecord::Base
  belongs_to :product
  belongs_to :parameter
end
