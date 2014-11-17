class Trade < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :trading_account

  attr_accessor :symbol_id, :exchange_name
end
