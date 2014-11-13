class Instrument < ActiveRecord::Base
  belongs_to :underlying
  belongs_to :exchange
end
