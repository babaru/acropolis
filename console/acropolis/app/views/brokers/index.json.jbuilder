json.array!(@brokers) do |broker|
  json.extract! broker, :id
  json.url broker_url(broker, format: :json)
end
