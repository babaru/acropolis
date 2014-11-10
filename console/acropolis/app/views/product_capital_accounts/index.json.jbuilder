json.array!(@product_capital_accounts) do |product_capital_account|
  json.extract! product_capital_account, :id
  json.url product_capital_account_url(product_capital_account, format: :json)
end
