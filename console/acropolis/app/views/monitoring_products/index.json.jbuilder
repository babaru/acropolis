json.array!(@monitoring_products) do |monitoring_product|
  json.extract! monitoring_product, :id
  json.url monitoring_product_url(monitoring_product, format: :json)
end
