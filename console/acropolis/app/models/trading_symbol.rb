class TradingSymbol < ActiveRecord::Base
  belongs_to :exchange
  belongs_to :currency
  has_many :instruments
  has_one :trading_symbol_margin
  has_one :margin, through: :trading_symbol_margin

  has_one :trading_symbol_trading_fee
  has_one :trading_fee, through: :trading_symbol_trading_fee

  accepts_nested_attributes_for :trading_fee
  accepts_nested_attributes_for :margin

  class << self

    def trading_symbol_types
      Acropolis::TradingSymbolTypes.trading_symbol_types.map{ |k,v| [I18n.t("trading_symbol_types.#{k}"),v] }
    end

    def trading_symbol_type_names
      Hash[Acropolis::TradingSymbolTypes.trading_symbol_types.map{ |k,v| [v, I18n.t("trading_symbol_types.#{k}")] }]
    end

  end
end
