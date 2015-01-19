class TradingAccountClearingCapital < ActiveRecord::Base
  belongs_to :trading_account

    scope :recent, ->(trading_account_id){
      where(TradingAccountClearingCapital.arel_table[:trading_account_id].eq(
        trading_account_id)).order(:cleared_at).reverse_order.first }
end
