class TradingAccountBudgetRecord < ActiveRecord::Base
  belongs_to :trading_account

  after_save :recalculate_trading_account_budget
  after_destroy :recalculate_trading_account_budget

  private

  def recalculate_trading_account_budget
    trading_account.budget = trading_account.trading_account_budget_records.inject(0) {|sum, item| sum += item.money}
    #trading_account.calculate_trading_summary
    #trading_account.save!
  end
end
