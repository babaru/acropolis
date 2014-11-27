json.array!(@trading_account_risk_plans) do |trading_account_risk_plan|
  json.extract! trading_account_risk_plan, :id
  json.url trading_account_risk_plan_url(trading_account_risk_plan, format: :json)
end
