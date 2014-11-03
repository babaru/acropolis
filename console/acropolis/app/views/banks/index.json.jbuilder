json.array!(@banks) do |bank|
  json.extract! bank, :id
  json.url bank_url(bank, format: :json)
end
