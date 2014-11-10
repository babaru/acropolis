json.array!(@trading_accounts) do |trading_account|
  json.extract! trading_account, :id
  json.url trading_account_url(trading_account, format: :json)
end
