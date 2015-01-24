class Instrument < ActiveRecord::Base
  belongs_to :exchange
  belongs_to :trading_symbol
  has_one :market_price
  has_many :clearing_prices

  attr_accessor :exchange_name, :symbol_id

  def latest_price
    return market_price.price if market_price
    return nil
  end

  def clearing_price(trading_date)
    result = clearing_prices.where(cleared_at: trading_date).first
    return result.price if result
    0
  end

  def multiplier
    trading_symbol.multiplier
  end

  def currency_exchange_rate
    trading_symbol.currency.exchange_rate
  end

  class << self

    def instrument_types
      Acropolis::InstrumentTypes.instrument_types.map{ |k,v| [I18n.t("instrument_types.#{k}"),v] }
    end

    def instrument_type_names
      Hash[Acropolis::InstrumentTypes.instrument_types.map{ |k,v| [v, I18n.t("instrument_types.#{k}")] }]
    end

  end

end
