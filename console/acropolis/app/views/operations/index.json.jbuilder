json.array!(@operations) do |operation|
  json.extract! operation, :id
  json.url operation_url(operation, format: :json)
end
