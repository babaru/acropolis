module ApplicationHelper
  def recent_items(type)
    type = type.to_s if type.is_a?(Symbol)
    session['recent'] ||= {}
    session['recent'][type] ||= {}
    logger.debug "helper: #{session['recent']}"
    session['recent'][type]
  end
end
