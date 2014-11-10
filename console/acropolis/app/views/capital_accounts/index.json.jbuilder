json.array!(@capital_accounts) do |capital_account|
  json.extract! capital_account, :id
  json.url capital_account_url(capital_account, format: :json)
end
