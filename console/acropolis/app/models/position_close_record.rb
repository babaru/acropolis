class PositionCloseRecord < ActiveRecord::Base
  belongs_to :open_trade, class_name: 'Trade', foreign_key: 'open_trade_id'
  belongs_to :close_trade, class_name: 'Trade', foreign_key: 'close_trade_id'
end
