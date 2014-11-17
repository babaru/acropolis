module Acropolis

class OrderSides < ::Settingslogic
  source "#{Rails.root}/config/acropolis/order_sides.yml"
  namespace Rails.env
end

end