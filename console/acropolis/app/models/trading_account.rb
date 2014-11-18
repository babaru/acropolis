class TradingAccount < ActiveRecord::Base
  belongs_to :product
  has_many :trades
  has_one :trading_account_trading_summary
  has_one :trading_summary, through: :trading_account_trading_summary

  def refresh_trading_summary
    TradingAccount.transaction do
      if self.trading_summary.nil?
        self.trading_summary = TradingSummary.new
        self.save
      end

      raw_summary = calculate_raw_summary

      self.trading_summary.customer_benefit = raw_summary[:customer_benefit]
      self.trading_summary.net_worth = raw_summary[:customer_benefit].fdiv(self.budget)
      self.trading_summary.save
    end
  end

  private

  def calculate_raw_summary
    open_position_profit = Trade.open.whose(self.id).inject(0) do |sum, trade|
      sum += (trade.is_buy? ? 1 : -1) * (1400 - trade.trade_price) * trade.open_volume
    end

    total_profit = 0
    close_position_profit = Trade.close.whose(self.id).inject(0) do |sum, trade|
      trade.open_trade_records.each do |open_trade_record|
        profit = trade.trade_price - open_trade_record.open_trade.trade_price
        close_profit = (trade.is_sell? ? 1 : -1) * profit * open_trade_record.close_volume
        total_profit += close_profit
      end
      sum = total_profit
    end

    {
      customer_benefit: self.budget + open_position_profit + close_position_profit
    }
  end
end
