module ApplicationHelper
  def recent_items(type)
    session[:recent] ||= {}
    session[:recent][type] ||= {}
    session[:recent][type]
  end
end
