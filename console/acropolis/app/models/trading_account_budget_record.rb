class TradingAccountBudgetRecord < ActiveRecord::Base
  belongs_to :trading_account

  after_save :recalculate_trading_account_budget
  after_destroy :recalculate_trading_account_budget

  private

  def recalculate_trading_account_budget
    self.trading_account.budget = self.trading_account.trading_account_budget_records.inject(0) {|sum, item| sum += item.value}
    self.trading_account.calculate_trading_summary
    self.trading_account.save!
  end
end
