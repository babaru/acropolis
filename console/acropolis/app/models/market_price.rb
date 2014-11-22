class MarketPrice < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :exchange

  attr_accessor :symbol_id
  attr_accessor :exchange_name
end
