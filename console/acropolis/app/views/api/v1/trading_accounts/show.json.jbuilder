json.trading_account do
  json.id             @trading_account.id
  json.name           @trading_account.name
  json.account_no     @trading_account.account_no
  json.trading_status @trading_account.trading_status
end