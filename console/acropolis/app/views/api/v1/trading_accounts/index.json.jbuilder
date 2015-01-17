json.trading_accounts @trading_accounts do |trading_account|
  json.partial! "trading_account", trading_account: trading_account
end