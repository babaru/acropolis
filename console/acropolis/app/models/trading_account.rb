class TradingAccount < ActiveRecord::Base
  belongs_to :product
  has_many :trades
  has_one :trading_account_trading_summary
  has_one :trading_summary, through: :trading_account_trading_summary
  has_many :trading_account_instruments, dependent: :destroy
  has_many :instruments, through: :trading_account_instruments

  def calculate_trading_summary
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
      self.trading_summary.profit = raw_summary[:customer_benefit] - self.budget
      self.trading_summary.save
    end
  end

  #
  # Trading summary delegates
  #
  %w(balance margin leverage exposure customer_benefit net_worth profit).each do |method_name|
    define_method(method_name) do
      return 0 unless self.trading_summary
      self.trading_summary.send(method_name.to_sym)
    end
  end

  private

  def calculate_raw_summary
    trading_fee = 0
    profit = 0
    margin = 0
    exposure = 0
    position_cost = 0

    self.trades.open.each do |open_trade|
      open_trade.reset_position
    end

    self.trades.close.each do |close_trade|
      close_trade.close_position
    end

    self.trades.each do |trade|
      profit += trade.profit
      position_cost += trade.position_cost
      trading_fee += trade.trading_fee
      margin += trade.margin
      exposure += trade.exposure
    end

    {
      customer_benefit: self.budget + profit - trading_fee,
      balance: self.budget - trading_fee - margin,
      leverage: position_cost / self.budget,
      margin: margin,
      exposure: exposure.abs,
    }
  end
end
