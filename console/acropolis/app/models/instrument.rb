class Instrument < ActiveRecord::Base
  belongs_to :underlying, class_name: 'Instrument', foreign_key: :underlying_id
  belongs_to :exchange

  has_many :derivaties
  has_one :trading_fee
  has_one :margin
  has_one :market_price

  accepts_nested_attributes_for :trading_fee
  accepts_nested_attributes_for :margin

  attr_accessor :underlying_name, :exchange_name

  def latest_price
    return market_price.price if market_price
    return nil
  end
end
