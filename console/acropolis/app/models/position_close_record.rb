class PositionCloseRecord < ActiveRecord::Base
  belongs_to :open_trade, class_name: 'Trade', foreign_key: 'open_trade_id'
  belongs_to :close_trade, class_name: 'Trade', foreign_key: 'close_trade_id'

  class << self
    def destroy_records(close_trade_id)
      PositionCloseRecord.where({close_trade_id: close_trade_id}).destroy_all
    end
  end
end
