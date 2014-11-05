module DashboardHelper
  def render_product_parameter(product, parameter)
    p = product.product_risk_parameters.where(parameter_id: parameter.id).first
    if p.nil?
      'N/A'
    else
      if parameter.name == 'in_bound_net_worth' || parameter.name == 'out_bound_net_worth'
        if p.value > 1
          p.value
        elsif p.value < 1 && p.value > 0.9
          content_tag(:span, p.value, class: "label label-warning", style: 'font-size: 14px; font-weight: bold;')
        else
          content_tag(:span, p.value, class: "label label-danger", style: 'font-size: 14px; font-weight: bold;')
        end
      else
        p.value
      end
    end
  end

end
