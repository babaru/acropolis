json.array!(@product_risk_plans) do |product_risk_plan|
  json.extract! product_risk_plan, :id
  json.url product_risk_plan_url(product_risk_plan, format: :json)
end
