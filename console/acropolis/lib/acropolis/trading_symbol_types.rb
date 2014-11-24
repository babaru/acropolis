module Acropolis

class TradingSymbolTypes < ::Settingslogic
  source "#{Rails.root}/config/acropolis/trading_symbol_types.yml"
  namespace Rails.env
end

end