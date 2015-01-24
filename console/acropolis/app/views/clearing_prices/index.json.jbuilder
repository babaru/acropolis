json.array!(@clearing_prices) do |clearing_price|
  json.extract! clearing_price, :id
  json.url clearing_price_url(clearing_price, format: :json)
end
