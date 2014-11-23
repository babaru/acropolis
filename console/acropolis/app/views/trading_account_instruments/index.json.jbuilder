json.array!(@trading_account_instruments) do |trading_account_instrument|
  json.extract! trading_account_instrument, :id
  json.url trading_account_instrument_url(trading_account_instrument, format: :json)
end
