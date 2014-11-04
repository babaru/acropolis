json.risk_event do
  json.id           @risk_event.id
  json.product_id   @risk_event.product_id
  json.operation_id @risk_event.operation_id
  json.remark       @risk_event.remark
  json.happened_at  @risk_event.happened_at
end