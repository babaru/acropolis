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
      self.trading_summary.margin = raw_summary[:margin]
      self.trading_summary.balance = raw_summary[:balance]
      self.trading_summary.leverage = raw_summary[:leverage]
      self.trading_summary.exposure = raw_summary[:exposure]
      self.trading_summary.profit = self.budget - raw_summary[:customer_benefit]
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
    profit = 0
    margin = 0
    exposure = 0
    position_cost = 0

    self.trades.each do |trade|
      profit += trade.profit
      position_cost += trade.position_cost
      trading_fee += trade.trading_fee
      margin += trade.margin
      exposure += trade.exposure
    end

    {
      customer_benefit: self.budget + profit - trading_fee,
      balance: self.budget - position_cost - trading_fee - margin,
      leverage: position_cost / self.budget,
      margin: margin,
      exposure: exposure.abs,
    }
  end
end
