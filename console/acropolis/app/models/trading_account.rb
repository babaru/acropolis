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

  def self.refresh_all_trading_summaries
    TradingAccount.transaction do
      Trade.reset_all_open_volumes
      PositionCloseRecord.delete_all
      Trade.all.order('traded_at asc').each { |trade| trade.adjust_open_volume }
    end
  end

  private

  def calculate_raw_summary
    trading_fee = 0
    total_profit = 0

    Trade.open.whose(self.id).each do |trade|
      total_profit += (trade.is_buy? ? 1 : -1) * (1400 - trade.trade_price) * trade.open_volume
      trading_fee += trade.instrument.trading_fee.calculate(trade)
    end

    Trade.close.whose(self.id).each do |trade|
      trade.open_trade_records.each do |open_trade_record|
        profit = trade.trade_price - open_trade_record.open_trade.trade_price
        close_profit = (trade.is_sell? ? 1 : -1) * profit * open_trade_record.close_volume
        total_profit += close_profit
      end
      trading_fee += trade.instrument.trading_fee.calculate(trade)
    end

    logger.debug("trading fee: #{trading_fee}")
    logger.debug("total profit: #{total_profit}")

    {
      customer_benefit: self.budget + total_profit - trading_fee
    }
  end
end
