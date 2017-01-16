module Acropolis

class Settings < ::Settingslogic
  source "#{Rails.root}/config/acropolis/settings.yml"
  namespace Rails.env
end

end