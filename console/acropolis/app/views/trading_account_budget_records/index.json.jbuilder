json.array!(@trading_account_budget_records) do |trading_account_budget_record|
  json.extract! trading_account_budget_record, :id
  json.url trading_account_budget_record_url(trading_account_budget_record, format: :json)
end
