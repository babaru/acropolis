class Trade < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :trading_account
end
