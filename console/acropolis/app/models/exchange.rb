class Exchange < ActiveRecord::Base
  has_many :instruments

  def is_derivatives_exchange?
    false
  end

  def generate_trade_sequence_number(trade)
    trade.system_trade_sequence_number = (Time.zone.now - Time.zone.now.beginning_of_day) * 1000.0 unless trade.system_trade_sequence_number > 0
  end

  def name
    self.short_cn_name
  end
end
