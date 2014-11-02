json.array!(@risk_plan_operations) do |risk_plan_operation|
  json.extract! risk_plan_operation, :id
  json.url risk_plan_operation_url(risk_plan_operation, format: :json)
end
