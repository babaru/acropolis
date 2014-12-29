class TradingSummary < ActiveRecord::Base
  include Acropolis::Calculators::TradingSummaryCalculator

  belongs_to :trading_account
  belongs_to :latest_trade, class_name: 'Trade'

  scope :when, -> (day) { where(trading_day: (day.beginning_of_day..day.end_of_day))}
  scope :of_exchange, -> (exchange_id) { where(exchange_id: exchange_id)}
  scope :whose, -> (trading_account_id) { where(trading_account_id: trading_account_id)}

  def self.find_or_create(trading_account_id, exchange_id, date)
    trading_summary = TradingSummary.find_by_trading_account_id_and_exchange_id_and_trading_date(trading_account_id, exchange_id, date.strftime('%Y-%m-%d'))
    trading_summary = TradingSummary.create(trading_account_id: trading_account_id, exchange_id: exchange_id, trading_date: date.strftime('%Y-%m-%d')) if trading_summary.nil?
    trading_summary
  end
end
