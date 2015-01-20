json.array!(@trading_summaries) do |trading_summary|
  json.extract! trading_summary, :id
  json.url trading_summary_url(trading_summary, format: :json)
end
