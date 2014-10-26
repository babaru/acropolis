json.array!(@risk_plans) do |risk_plan|
  json.extract! risk_plan, :id
  json.url risk_plan_url(risk_plan, format: :json)
end
