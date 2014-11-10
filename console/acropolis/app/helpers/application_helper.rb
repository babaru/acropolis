module ApplicationHelper
  def recent_items(type)
    type = type.to_s if type.is_a?(Symbol)
    session['recent'] ||= {}
    session['recent'][type] ||= {}
    session['recent'][type]
  end

  def render_budget(value)
    content_tag(:div, number_with_delimiter(value, delimiter: ','), class: 'label label-success', style: 'font-size: 14px;')
  end
end
