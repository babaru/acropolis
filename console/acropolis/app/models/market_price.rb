class MarketPrice < ActiveRecord::Base
  belongs_to :instrument

  attr_accessor :symbol_id
end
