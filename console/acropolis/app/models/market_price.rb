class MarketPrice < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :exchange

  attr_accessor :price_updated_at
end
