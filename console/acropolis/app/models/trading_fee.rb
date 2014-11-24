class TradingFee < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :currency
end
