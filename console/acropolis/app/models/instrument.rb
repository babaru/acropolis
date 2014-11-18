class Instrument < ActiveRecord::Base
  belongs_to :underlying, class_name: 'Instrument', foreign_key: :underlying_id
  belongs_to :exchange

  has_many :derivaties
  has_one :trading_fee
  has_one :margin

  accepts_nested_attributes_for :trading_fee
  accepts_nested_attributes_for :margin

  attr_accessor :underlying_name, :exchange_name
end
