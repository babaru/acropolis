class Instrument < ActiveRecord::Base
  belongs_to :exchange
  belongs_to :trading_symbol
  has_one :market_price

  attr_accessor :exchange_name, :symbol_id

  def latest_price
    return market_price.price if market_price
    return nil
  end

  def margin_value
    return 0 if self.margin.nil?
    self.margin.value
  end

  def margin_percentage
    self.margin_value * 100
  end

  def multiplier
    trading_symbol.multiplier
  end

  class << self

    def instrument_types
      Acropolis::InstrumentTypes.instrument_types.map{ |k,v| [I18n.t("instrument_types.#{k}"),v] }
    end

  end

end
