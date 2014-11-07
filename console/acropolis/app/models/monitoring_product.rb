class MonitoringProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :user

  attr_accessor :product_name
end
