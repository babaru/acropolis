class TradingSymbolMargin < ActiveRecord::Base
  belongs_to :trading_symbol
  belongs_to :margin
end
