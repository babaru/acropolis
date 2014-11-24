json.array!(@trading_symbols) do |trading_symbol|
  json.extract! trading_symbol, :id
  json.url trading_symbol_url(trading_symbol, format: :json)
end
