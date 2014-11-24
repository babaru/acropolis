module Acropolis

class InstrumentTypes < ::Settingslogic
  source "#{Rails.root}/config/acropolis/instrument_types.yml"
  namespace Rails.env
end

end