module Acropolis

class TradeOpenFlags < ::Settingslogic
  source "#{Rails.root}/config/acropolis/trade_open_flags.yml"
  namespace Rails.env
end

end