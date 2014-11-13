class Instrument < ActiveRecord::Base
  belongs_to :underlying, class_name: 'Instrument', foreign_key: :underlying_id
  belongs_to :exchange

  has_many :derivaties
end
