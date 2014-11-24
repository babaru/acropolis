class MarketPrice < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :exchange

  attr_accessor :exchange_name, :security_code
end
