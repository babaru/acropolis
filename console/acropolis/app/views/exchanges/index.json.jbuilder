json.array!(@exchanges) do |exchange|
  json.extract! exchange, :id
  json.url exchange_url(exchange, format: :json)
end
