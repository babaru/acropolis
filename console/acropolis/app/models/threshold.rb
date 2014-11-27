class Threshold < ActiveRecord::Base
  belongs_to :risk_plan_operation
  belongs_to :relation_symbol
  belongs_to :parameter

  # validates :risk_plan_id, presence: true
  # validates :relation_symbol_id, presence: true
  def is_matched?(product)
    product_value = nil
    if parameter.name.to_sym == :net_worth
      product_value = product.net_worth
    elsif parameter.name.to_sym == :margin
      product_value = product.margin
    elsif parameter.name.to_sym == :exposure
      product_value = product.exposure
    end

    return relation_symbol.is_matched?(value, product_value)
  end
end
