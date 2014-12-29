json.trades @trades do |trade|
  json.partial! "trade", trade: trade
end