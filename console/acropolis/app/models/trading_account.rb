class TradingAccount < ActiveRecord::Base
  belongs_to :product
  has_many :trades
end
