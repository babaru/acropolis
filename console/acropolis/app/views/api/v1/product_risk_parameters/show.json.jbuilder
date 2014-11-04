json.product_risk_parameter do
  json.id           @product_risk_parameter.id
  json.product_id   @product_risk_parameter.product_id
  json.parameter_id @product_risk_parameter.parameter_id
  json.value        @product_risk_parameter.value
  json.happened_at  @product_risk_parameter.happened_at
end